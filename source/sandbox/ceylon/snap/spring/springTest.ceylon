import ceylon.collection {
    LinkedList
}
import ceylon.dbc {
    Sql,
    newConnectionFromDataSource
}
import ceylon.interop.java {
    javaClass
}
import ceylon.time {
    Instant,
    now
}

import javax.inject {
    inject
}
import javax.sql {
    DataSource
}

import org.apache.tomcat.jdbc.pool {
    TomcatDataSource=DataSource
}
import org.aspectj.lang {
    ProceedingJoinPoint
}
import org.aspectj.lang.annotation {
    aspect,
    around
}
import org.springframework.context.annotation {
    AnnotationConfigApplicationContext,
    configuration,
    enableAspectJAutoProxy,
    componentScan,
    bean,
    propertySource
}
import org.springframework.core.env {
    Environment
}
import org.springframework.jdbc.datasource {
    TransactionAwareDataSourceProxy,
    DataSourceTransactionManager
}
import org.springframework.stereotype {
    service,
    component,
    repository
}
import org.springframework.transaction {
    PlatformTransactionManager
}
import org.springframework.transaction.annotation {
    enableTransactionManagement,
    transactional
}
import javax.annotation {
    postConstruct
}

late Instant startupTime;

/////////////////////////////////////////////////
//
// Run Method
//
/////////////////////////////////////////////////

shared void run() {
    value ctx = AnnotationConfigApplicationContext(javaClass<AppConfig>());
    assert(is Application application = ctx.getBean("application"));
    application.main();
}

/////////////////////////////////////////////////
//
// Configuration
//
/////////////////////////////////////////////////

configuration
propertySource {
    ignoreResourceNotFound = true;
    \ivalue = {"classpath:/application.properties"};
}
componentScan({"sandbox.ceylon.snap.spring"})
enableAspectJAutoProxy(false)
enableTransactionManagement
class AppConfig() {

    late Environment environment;

    inject void setEnvironment(Environment environment)
        =>  this.environment = environment;

    shared bean default Instant startupTime()
        =>  now();

    shared bean default DataSource rawDataSource() {
        value ds = TomcatDataSource();
        ds.driverClassName = environment.getProperty("jdbc.driver", "org.h2.Driver");
        ds.url = environment.getProperty("jdbc.url", "jdbc:h2:mem:db1");
        ds.validationQuery = environment.getProperty("jdbc.query", "select 1");
        if (exists username = environment.getProperty("jdbc.username")) {
            ds.username = username;
        }
        if (exists password = environment.getProperty("jdbc.password")) {
            ds.username = password;
        }
        return ds;
    }

    shared bean default TransactionAwareDataSourceProxy dataSource()
        =>  TransactionAwareDataSourceProxy(rawDataSource());

    shared bean default PlatformTransactionManager txManager()
        =>  DataSourceTransactionManager(rawDataSource());

    // TODO Review Sql's use of thread locals
    shared bean default Sql sql()
        =>  Sql(newConnectionFromDataSource(dataSource()));
}

component aspect class AspectConfigs() {
    around("execution(* Repository.*(..))")
    shared Anything profile(ProceedingJoinPoint pjp) {
        value start = system.nanoseconds;
        try {
            Anything result = pjp.proceed();
            return result;
        } finally {
            print("        (execution time for ``pjp.string`` " +
                "was ``system.nanoseconds - start``ns");
        }
    }
}

/////////////////////////////////////////////////
//
// Application
//
/////////////////////////////////////////////////

service class Application {
    Repository repository;

    shared inject new Application(
                Repository repository,
                Instant startupTime) {
        this.repository = repository;
        package.startupTime = startupTime;
    }

    shared void main() {
        print("Application started at ``startupTime.dateTime()``");
        repository.insertRows();
        repository.selectRows().each(print);

        // transaction rollback test
        value rowCount = repository.selectRows().size;
        assert(rowCount > 0);
        try {
            repository.deleteRows(true);
        }
        catch (Exception e) { /* ignore */ }
        assert(rowCount == repository.selectRows().size);
        print ("deleteRows() was rolled back!");

        // transaction commit test
        repository.deleteRows(false);
        assert(0 == repository.selectRows().size);
        print ("deleteRows() was committed!");
    }
}

shared class Language(Integer id, String name) {
    shared actual String string => "``id``, ``name``";
}

interface Repository {
    shared formal void insertRows();
    shared formal void deleteRows(Boolean fail);
    shared formal List<Language> selectRows();
}

transactional repository class RepositorySql satisfies Repository {
    Sql sql;

    shared inject new RepositorySql(Sql sql) {
        this.sql = sql;
    }

    postConstruct shared void initialize() {
        sql.Statement("create table jvm_langs(
                            id bigint primary key,
                            name varchar(100))").execute();
    }

    shared actual void insertRows() {
        value insert = "insert into jvm_langs values (?, ?)";
        sql.Statement(insert).execute(1, "Ceylon");
        sql.Statement(insert).execute(2, "Groovy");
        sql.Statement(insert).execute(3, "Jacl");
    }

    shared actual void deleteRows(Boolean fail) {
        sql.Statement("delete from jvm_langs").execute();
        if (fail) {
            throw; // trigger rollback
        }
    }

    shared actual List<Language> selectRows() {
        value result = LinkedList<Language>();
        sql.Select("select id, name from jvm_langs")
                .forEachRow()(void(row) {
            assert (is Integer id = row["id"]);
            assert (is String name = row["name"]);
            result.add(Language(id, name));
        });
        return result;
    }
}
