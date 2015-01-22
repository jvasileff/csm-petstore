import ceylon.language.meta.declaration {
    Module,
    Package
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
    ltrace=trace
}

import org.apache.log4j {
    L4JLogger=Logger,
    Level
}

Logger log4jLogger(Category category) {
    value delegate = L4JLogger.getLogger(category.qualifiedName);
    value cat = category; // naming collision

    Level levelFrom(Priority priority)
        =>  switch(priority)
            case(lfatal) Level.\iFATAL
            case(lerror) Level.\iERROR
            case(lwarn)  Level.\iWARN
            case(linfo)  Level.\iINFO
            case(ldebug) Level.\iDEBUG
            case(ltrace) Level.\iTRACE;

    Priority priorityFrom(Level? level)
        =>  if (!exists level)               then ltrace // null => trace
            else if (level == Level.\iALL)   then ltrace // ALL  => trace
            else if (level == Level.\iDEBUG) then ldebug
            else if (level == Level.\iERROR) then lerror
            else if (level == Level.\iFATAL) then lfatal
            else if (level == Level.\iINFO)  then linfo
            else if (level == Level.\iOFF)   then lfatal // OFF  => fatal
            else if (level == Level.\iTRACE) then ltrace
            else if (level == Level.\iWARN)  then lwarn
            else ltrace; // default trace

    return object satisfies Logger {
        shared actual Module|Package category = cat;

        shared actual void log(
                Priority priority,
                String|String() message,
                Exception? exception) {

            value level = levelFrom(priority);
            if (delegate.isEnabledFor(level)) {
                String msg = if (is String() message)
                             then message()
                             else message;
                if (exists exception) {
                    delegate.log(levelFrom(priority),
                                 msg, exception);
                }
                else {
                    delegate.log(levelFrom(priority),
                                 msg);
                }
            }
        }

        shared actual Priority priority
            =>  priorityFrom(delegate.level
                    else delegate.rootLogger.level);

        assign priority
            =>  delegate.setPriority(levelFrom(priority));
    };
}
