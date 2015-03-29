import com.vasileff.csmpetstore.support {
    log
}

import org.springframework.context {
    ApplicationListener
}
import org.springframework.security.authentication.event {
    AbstractAuthenticationFailureEvent
}

shared
class CsmAuthenticationFailureListener()
        satisfies ApplicationListener<AbstractAuthenticationFailureEvent> {

    shared actual
    void onApplicationEvent(AbstractAuthenticationFailureEvent event) {
        value principal = event.authentication.principal.string;
        value message = event.exception.message;
        log.info("Authentication failure for principal='{}', message='{}'",
                 principal, message);
    }
}
