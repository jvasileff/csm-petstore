import ceylon.interop.java {
    CeylonIterable
}

import com.vasileff.csmpetstore.support {
    log
}

import org.springframework.context {
    ApplicationListener
}
import org.springframework.core {
    Ordered
}
import org.springframework.security.core.userdetails {
    User
}
import org.springframework.security.web.session {
    HttpSessionDestroyedEvent
}

shared
class CsmSessionDestroyedListener()
        satisfies ApplicationListener<HttpSessionDestroyedEvent> & Ordered {

    shared actual
    void onApplicationEvent(HttpSessionDestroyedEvent event) {
        for (context in CeylonIterable(event.securityContexts)) {
            assert (is User details = context.authentication.principal);
            log.info("Session destroyed for username='{}', authorities='{}'",
                     details.username, details.authorities);
        }
    }

    shared actual
    Integer order => 0;
}
