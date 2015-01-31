import ceylon.interop.java {
    createJavaObjectArray
}
import ceylon.time {
    now,
    Instant
}

import com.vasileff.csmpetstore.mapper.support {
    InstantTypeHandler,
    StringTypeHandler,
    IntegerTypeHandler
}

import javax.inject {
    inject__SETTER
}
import javax.sql {
    DataSource
}

import org.apache.ibatis.session {
    SqlSession,
    LocalCacheScope,
    SqlSessionFactory
}
import org.apache.ibatis.type {
    TypeHandler
}
import org.apache.tomcat.jdbc.pool {
    TomcatDataSource=DataSource
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
    bean,
    propertySource,
    enableAspectJAutoProxy,
    componentScan,
    configuration
}
import org.springframework.core.env {
    Environment
}
import org.springframework.jdbc.datasource {
    DataSourceTransactionManager,
    TransactionAwareDataSourceProxy
}
import org.springframework.stereotype {
    Component
}
import org.springframework.transaction {
    PlatformTransactionManager
}
import org.springframework.transaction.annotation {
    enableTransactionManagement
}
import javax.validation {
    Validator
}
import org.springframework.validation.beanvalidation {
    LocalValidatorFactoryBean
}

propertySource {
    ignoreResourceNotFound = true;
    \ivalue = {"classpath:/application.properties"};
}
componentScan({
    "com.vasileff.csmpetstore.dao",
    "com.vasileff.csmpetstore.service"
})
mapperScan {
    basePackages = { "com.vasileff.csmpetstore.mapper" };
    sqlSessionFactoryRef = "sqlSessionFactory";
    annotationClass = `interface Component`;
}
enableAspectJAutoProxy(false)
enableTransactionManagement
configuration shared
class AppConfig() {

    late inject__SETTER
    Environment environment;

    shared default bean
    Instant startupTime()
        =>  now();

    shared default bean{destroyMethod="close";}
    DataSource rawDataSource() {
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

    shared bean default
    TransactionAwareDataSourceProxy dataSource()
        =>  TransactionAwareDataSourceProxy(rawDataSource());

    shared bean default
    PlatformTransactionManager txManager()
        =>  DataSourceTransactionManager(rawDataSource());

    shared bean default
    Validator validator()
        =>  LocalValidatorFactoryBean();

    shared bean default
    SqlSessionFactory sqlSessionFactory(
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
        //ssfb.setTypeHandlersPackage("com.vasileff.csmpetstore.mapper.h2");

        // scan for mapper and result map XML
        ssfb.setMapperLocations(applicationContext.getResources(
            "classpath:com/vasileff/csmpetstore/mapper/*.xml"));

        SqlSessionFactory sqlSessionFactory = ssfb.\iobject;

        // see http://code.google.com/p/mybatis/issues/detail?id=482
        // and http://code.google.com/p/mybatis/issues/detail?id=126
        sqlSessionFactory.configuration.localCacheScope = LocalCacheScope.\iSTATEMENT;
        sqlSessionFactory.configuration.cacheEnabled = false;
        sqlSessionFactory.configuration.lazyLoadingEnabled = false;
        sqlSessionFactory.configuration.callSettersOnNulls = true;

        return sqlSessionFactory;
    }

    shared bean default
    SqlSession sqlSession(SqlSessionFactory ssf)
        =>  SqlSessionTemplate(ssf);

}