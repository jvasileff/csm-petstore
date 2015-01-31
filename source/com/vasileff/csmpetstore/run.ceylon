import ceylon.interop.java {
    javaClass
}
import ceylon.logging {
    logger,
    Logger
}

import com.vasileff.csmpetstore.config {
    AppConfig
}
import com.vasileff.csmpetstore.logging {
    useLog4jLogger
}
import com.vasileff.csmpetstore.service {
    Application
}

import org.apache.log4j {
    JLog4jLogger=Logger,
    ConsoleAppender,
    PatternLayout,
    Level
}
import org.springframework.context.annotation {
    AnnotationConfigApplicationContext
}

Logger log = logger(`package`);

shared void initializeLogger() {
    value console = ConsoleAppender();
    value pattern = "%-5p [%t:%X{reference}] (%F:%L) - %m%n";
    // %d %-5p [%t:%X{reference}] %c - %m%n
    console.layout = PatternLayout(pattern);
    console.threshold = Level.\iINFO;
    console.activateOptions();
    JLog4jLogger.rootLogger.addAppender(console);
    JLog4jLogger.rootLogger.setPriority(Level.\iDEBUG);
    useLog4jLogger();
}

shared void run() {
    initializeLogger();
    value ctx = AnnotationConfigApplicationContext(javaClass<AppConfig>());
    assert(is Application application = ctx.getBean("application"));
    application.main();
}
