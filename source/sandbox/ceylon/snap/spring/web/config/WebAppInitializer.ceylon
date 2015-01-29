import ceylon.interop.java {
    createJavaObjectArray,
    javaClass,
    createJavaStringArray
}
import ceylon.logging {
    Logger,
    logger
}

import com.redhat.ceylon.war {
    WarInitializer
}

import java.lang {
    Class,
    ObjectArray,
    JString=String
}
import java.util {
    EnumSet {
        enumSetOfAll=allOf
    }
}

import javax.servlet {
    ServletContext,
    DispatcherType
}

import org.apache.log4j {
    Level,
    ConsoleAppender,
    PatternLayout,
    L4JLogger=Logger
}
import org.springframework.core.annotation {
    order
}
import org.springframework.web.filter {
    DelegatingFilterProxy
}
import org.springframework.web.servlet.support {
    AbstractAnnotationConfigDispatcherServletInitializer
}

import sandbox.ceylon.snap.spring {
    useLog4jLogger
}

Logger log = logger(`package`);

// FIXME interop - in java we can do Integer.MIN_VALUE
shared order(-1000) // process first so that our filters will run first
class WebAppInitializer()
extends AbstractAnnotationConfigDispatcherServletInitializer() {

    shared actual String servletName = "csmPetstore";

    shared actual
    void onStartup(ServletContext servletContext) {
        // initialize Ceylon
        //CeylonConfig.setup(servletContext);
        initializeCeylon(servletContext);

        // initialize logging
        initializeLogger();
        log.info("Logging Initialized");

        // configure filters that should run before Sring Security filter
        value dfp = DelegatingFilterProxy();
        dfp.setTargetFilterLifecycle(false); // emphasizing the default
        value reg = servletContext.addFilter("webAppFilters", dfp);
        reg.addMappingForUrlPatterns(
            enumSetOfAll(javaClass<DispatcherType>()),
            false, "/*");

        // configure other servlets

        // Spring context, dispatcher servlet, and dispatcher servlet filters
        super.onStartup(servletContext);
    }

    shared actual
    ObjectArray<Class<out Object>> rootConfigClasses
        =>  createJavaObjectArray { javaClass<WebAppConfig>() };

    shared actual
    ObjectArray<Class<out Object>> servletConfigClasses
        =>  createJavaObjectArray { javaClass<MvcConfig>() };

    shared actual
    ObjectArray<JString> servletMappings
        =>  createJavaStringArray({ "/" });
}

void initializeLogger() {
    // TODO use servlet config instead:
    //Log4jServletContextListener log4jListener = Log4jServletContextListener();
    //log4jListener.configureLog4j(servletContext);
    //servletContext.addListener(log4jListener);

    value console = ConsoleAppender();
    value pattern = "....[%p|%c] %m%n";
    console.layout = PatternLayout(pattern);
    console.threshold = Level.\iINFO;
    console.activateOptions();
    L4JLogger.rootLogger.addAppender(console);

    useLog4jLogger();
}

void initializeCeylon(ServletContext servletContext) {
    value warInitializer = WarInitializer();
    warInitializer.initialize(servletContext);
    servletContext.addListener(warInitializer);
}
