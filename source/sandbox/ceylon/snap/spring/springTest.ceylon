import ceylon.dbc {
    Sql,
    newConnectionFromDataSource
}
import ceylon.interop.java {
    javaClass,
    createJavaObjectArray,
    CeylonList
}
import ceylon.logging {
    logger,
    Logger
}
import ceylon.time {
    Instant,
    now
}

import javax.annotation {
    postConstruct
}
import javax.inject {
    inject,
    inject__SETTER
}
import javax.sql {
    DataSource
}

import org.apache.ibatis.session {
    SqlSessionFactory,
    LocalCacheScope,
    SqlSession
}
import org.apache.ibatis.type {
    TypeHandler
}
import org.apache.log4j {
    L4JLogger=Logger,
    ConsoleAppender,
    PatternLayout,
    Level
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
import org.mybatis.spring {
    SqlSessionFactoryBean,
    SqlSessionTemplate
}
import org.mybatis.spring.annotation {
    mapperScan
}
import org.springframework.context {
    ApplicationContext
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
    Component,
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

import sandbox.ceylon.snap.spring.domain {
    Language
}
import sandbox.ceylon.snap.spring.logging {
    useLog4jLogger
}
import sandbox.ceylon.snap.spring.mapper {
    LanguageMapper
}
import sandbox.ceylon.snap.spring.mapper.support {
    InstantTypeHandler,
    IntegerTypeHandler,
    StringTypeHandler
}

late Instant startupTime;

/////////////////////////////////////////////////
//
// Run Method
//
/////////////////////////////////////////////////
shared void runCommandline() {
    initializeLogger();
    value ctx = AnnotationConfigApplicationContext(javaClass<AppConfig>());
    assert(is Application application = ctx.getBean("application"));
    application.main();
}

shared void run() {
    print("this run method is dumb");
}

/////////////////////////////////////////////////
//
// Logging
//
/////////////////////////////////////////////////
Logger log = logger(`package sandbox.ceylon.snap.spring`);

shared void initializeLogger() {
    value console = ConsoleAppender();
    value pattern = "%-5p [%t:%X{reference}] (%F:%L) - %m%n";
    // %d %-5p [%t:%X{reference}] %c - %m%n
    console.layout = PatternLayout(pattern);
    console.threshold = Level.\iINFO;
    console.activateOptions();
    L4JLogger.rootLogger.addAppender(console);

    useLog4jLogger();
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
mapperScan {
    basePackages = { "sandbox.ceylon.snap.spring.mapper" };
    sqlSessionFactoryRef = "sqlSessionFactory";
    annotationClass = `interface Component`;
}
class AppConfig() {

    late inject__SETTER Environment environment;

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

    shared bean default SqlSessionFactory sqlSessionFactory(
            ApplicationContext applicationContext) {

        SqlSessionFactoryBean ssfb = SqlSessionFactoryBean();
        ssfb.setDataSource(dataSource());

        // manually set TypeHandlers
        ssfb.setTypeHandlers(createJavaObjectArray
                <TypeHandler<out Object>>({
            IntegerTypeHandler(),
            StringTypeHandler(),
            InstantTypeHandler()
            //LocalDateTypeHandler(),
            //LocalTimeTypeHandler(),
            //LocalDateTimeTypeHandler() }
        }));

        // scan for TypeHandlers
        ssfb.setTypeHandlersPackage("sandbox.ceylon.snap.mapper.h2");

        // scan for mapper and result map XML
        ssfb.setMapperLocations(applicationContext.getResources(
            "classpath:sandbox/ceylon/snap/spring/mapper/*.xml"));

        SqlSessionFactory sqlSessionFactory = ssfb.\iobject;

        // see http://code.google.com/p/mybatis/issues/detail?id=482
        // and http://code.google.com/p/mybatis/issues/detail?id=126
        sqlSessionFactory.configuration.localCacheScope = LocalCacheScope.\iSTATEMENT;
        sqlSessionFactory.configuration.cacheEnabled = false;
        sqlSessionFactory.configuration.lazyLoadingEnabled = false;
        sqlSessionFactory.configuration.callSettersOnNulls = true;

        return sqlSessionFactory;
    }

    shared bean default SqlSession sqlSession(SqlSessionFactory ssf)
        =>  SqlSessionTemplate(ssf);
}

component aspect class AspectConfigs() {
    around("execution(* Repository.*(..))")
    shared Anything profile(ProceedingJoinPoint pjp) {
        value start = system.nanoseconds;
        try {
            Anything result = pjp.proceed();
            return result;
        } finally {
            log.info("elapsed time for ``pjp.string``: " +
                     "``system.nanoseconds - start``ns");
        }
    }
}

/////////////////////////////////////////////////
//
// Application
//
/////////////////////////////////////////////////
service inject class Application(
        Repository repository,
        Instant startupTime,
        LanguageMapper languageMapper) {

    package.startupTime = startupTime;

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

interface Repository {
    shared formal void insertRows();
    shared formal void deleteRows(Boolean fail);
    shared formal List<Language> selectRows();
}

transactional repository inject class RepositorySql(
        Sql sql,
        LanguageMapper languageMapper)
        satisfies Repository {

    postConstruct shared void initialize()
        =>  languageMapper.initialize();

    shared actual List<Language> selectRows()
        =>  CeylonList(languageMapper.findAll());

    shared actual void insertRows() {
        languageMapper.create(Language.Of(1, "Ceylon"));
        languageMapper.create(Language.Of(2, "Groovy"));
        languageMapper.create(Language.Of(3, "Jacl"));
    }

    shared actual void deleteRows(Boolean fail) {
        for (language in CeylonList(languageMapper.findAll())) {
            assert(exists id = language.id);
            languageMapper.delete(id);
        }
        if (fail) {
            throw; // trigger rollback
        }
    }
}
