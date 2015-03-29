import ceylon.time {
    Instant
}

import com.vasileff.csmpetstore.domain {
    Account
}
import com.vasileff.csmpetstore.domain.support {
    createDomainObject
}
import com.vasileff.csmpetstore.mapper {
    LanguageMapper
}
import com.vasileff.csmpetstore.support {
    log
}

import javax.inject {
    inject
}
import javax.validation {
    Validator
}

import org.aspectj.lang {
    ProceedingJoinPoint
}
import org.aspectj.lang.annotation {
    aspect,
    around
}
import org.springframework.stereotype {
    service,
    component
}

service inject shared
class Application(
        Repository repository,
        Instant startupTime,
        LanguageMapper languageMapper,
        Validator validator) {

    shared
    void main() {
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

        value account = createDomainObject(`Account`);
        print(account);
        account.username="#@jvasileff";
        account.fullName="name";
        account.email="john@vasileff.com";
        account.country="US";
        
        print(account);
        print(account.hash);
        
        value result = validator.validate(account);
        print(result);
    }
}

shared component aspect
class AspectConfigs() {

    shared around("execution(* Repository.*(..))")
    Anything profile(ProceedingJoinPoint pjp) {
        value start = system.nanoseconds;
        try {
            Anything result = pjp.proceed();
            return result;
        } finally {
            log.info("Elapsed time for '{}': {}ns",
                     pjp, system.nanoseconds - start);
        }
    }
}
