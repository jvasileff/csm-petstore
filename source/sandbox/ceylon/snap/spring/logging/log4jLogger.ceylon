import ceylon.interop.java {
    javaClass
}
import ceylon.logging {
    Category,
    Logger,
    Priority,
    lfatal=fatal,
    lerror=error,
    lwarn=warn,
    linfo=info,
    ldebug=debug,
    ltrace=trace,
    logger
}

import org.apache.log4j {
    L4JLogger=Logger,
    Level
}

shared void useLog4jLogger()
    =>  logger = log4jLogger;

shared Logger log4jLogger(Category category)
    =>  Log4jLoggerWrapper(category);

String loggerFqcn = javaClass<Log4jLoggerWrapper>().name;

class Log4jLoggerWrapper(category) satisfies Logger {

    shared actual Category category;

    value delegate = L4JLogger.getLogger(category.qualifiedName);

    shared actual void log(
        Priority priority,
        String|String() message,
        Exception? exception) {

        value level = levelFrom(priority);
        if (delegate.isEnabledFor(level)) {
            String msg = if (is String() message)
                         then message()
                         else message;

            delegate.log(
                loggerFqcn, levelFrom(priority), msg, exception);
        }
    }

    shared actual Priority priority
        =>  priorityFrom(delegate.level else delegate.rootLogger.level);

    assign priority
        =>  delegate.setPriority(levelFrom(priority));

    Level levelFrom(Priority priority)
        =>  switch(priority)
            case(ltrace) Level.\iTRACE
            case(ldebug) Level.\iDEBUG
            case(linfo)  Level.\iINFO
            case(lwarn)  Level.\iWARN
            case(lerror) Level.\iERROR
            case(lfatal) Level.\iFATAL;

    Priority priorityFrom(Level? level)
        =>  if (!exists level)               then ltrace // null => trace
            else if (level == Level.\iALL)   then ltrace // ALL  => trace
            else if (level == Level.\iTRACE) then ltrace
            else if (level == Level.\iDEBUG) then ldebug
            else if (level == Level.\iINFO)  then linfo
            else if (level == Level.\iWARN)  then lwarn
            else if (level == Level.\iERROR) then lerror
            else if (level == Level.\iFATAL) then lfatal
            else if (level == Level.\iOFF)   then lfatal // OFF  => fatal
            else ltrace; // default trace

}
