import com.vasileff.csmpetstore.mapper {
    LanguageMapper
}
import ceylon.time {
    Instant
}
import javax.inject {
    inject
}
import org.springframework.stereotype {
    service,
    component
}
import org.aspectj.lang.annotation {
    aspect,
    around
}
import org.aspectj.lang {
    ProceedingJoinPoint
}
import ceylon.logging {
    Logger,
    logger
}

service inject shared
class Application(
        Repository repository,
        Instant startupTime,
        LanguageMapper languageMapper) {

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

Logger log = logger(`package com.vasileff.csmpetstore`);

shared component aspect
class AspectConfigs() {
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