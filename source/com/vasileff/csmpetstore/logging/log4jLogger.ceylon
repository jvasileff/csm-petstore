import ceylon.collection {
    HashMap,
    MutableMap
}
import ceylon.interop.java {
    javaClass,
    CeylonIterable
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

import java.util {
    JMap=Map
}

import org.apache.log4j {
    Log4jLogger=Logger,
    Log4jLevel=Level,
    Log4jMdc=MDC
}

shared
void useLog4jLogger() {
    logger = log4jLogger;
    mdc = log4jMdc;
}

shared
Logger log4jLogger(Category category)
    =>  Log4jLoggerWrapper(category);

String loggerFqcn = javaClass<Log4jLoggerWrapper>().name;

class Log4jLoggerWrapper(category)
        satisfies Logger {

    shared actual
    Category category;

    value delegate = Log4jLogger.getLogger(category.qualifiedName);

    shared actual
    void log(
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

    shared actual
    Priority priority
        =>  priorityFrom(delegate.level else delegate.rootLogger.level);

    assign priority
        =>  delegate.setPriority(levelFrom(priority));

    Log4jLevel levelFrom(Priority priority)
        =>  switch(priority)
            case(ltrace) Log4jLevel.\iTRACE
            case(ldebug) Log4jLevel.\iDEBUG
            case(linfo)  Log4jLevel.\iINFO
            case(lwarn)  Log4jLevel.\iWARN
            case(lerror) Log4jLevel.\iERROR
            case(lfatal) Log4jLevel.\iFATAL;

    Priority priorityFrom(Log4jLevel? level)
        =>  if (!exists level)                    then ltrace // null => trace
            else if (level == Log4jLevel.\iALL)   then ltrace // ALL  => trace
            else if (level == Log4jLevel.\iTRACE) then ltrace
            else if (level == Log4jLevel.\iDEBUG) then ldebug
            else if (level == Log4jLevel.\iINFO)  then linfo
            else if (level == Log4jLevel.\iWARN)  then lwarn
            else if (level == Log4jLevel.\iERROR) then lerror
            else if (level == Log4jLevel.\iFATAL) then lfatal
            else if (level == Log4jLevel.\iOFF)   then lfatal // OFF  => fatal
            else ltrace; // default trace
}

shared
object log4jMdc satisfies Mdc {

    shared actual
    void clear()
        =>  Log4jMdc.clear();

    shared actual
    MutableMap<String,String> clone()
        =>  HashMap {*this};

    shared actual
    Boolean defines(Object key)
        =>  get(key) exists;

    shared actual
    String? get(Object key)
        =>  if (is String key,
                is String val = Log4jMdc.get(key))
            then val
            else null;

    shared actual
    Iterator<String->String> iterator()
            // https://github.com/ceylon/ceylon-compiler/issues/2028
        =>  let(JMap<out Object, out Object>? ctx = Log4jMdc.context)
            if (exists set = ctx?.entrySet())
            then { for (entry in CeylonIterable(set))
                    if (is String key = entry.key,
                        is String item = entry.\ivalue)
                    key->item }.iterator()
            else emptyIterator;

    shared actual
    String? put(String key, String item) {
        value oldValue = get(key);
        Log4jMdc.put(key, item);
        return oldValue;
    }

    shared actual
    String? remove(String key) {
        value oldValue = get(key);
        Log4jMdc.remove(key);
        return oldValue;
    }

    shared actual
    Boolean equals(Object that)
        =>  (super of Mdc).equals(that);

    shared actual
    Integer hash
        =>  (super of Mdc).hash;

}