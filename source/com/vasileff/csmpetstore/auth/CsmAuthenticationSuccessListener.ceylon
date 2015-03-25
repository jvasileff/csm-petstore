import org.springframework.context {
    ApplicationListener
}
import org.springframework.security.authentication.event {
    InteractiveAuthenticationSuccessEvent
}
import org.springframework.security.core.userdetails {
    User
}

shared
class CsmAuthenticationSuccessListener()
        satisfies ApplicationListener<InteractiveAuthenticationSuccessEvent> {

    shared actual
    void onApplicationEvent(InteractiveAuthenticationSuccessEvent event) {
        assert (is User details = event.authentication.principal);
        log.info("Authentication success for " +
                 "username='``details.username``, " +
                 "authorities='``details.authorities``'");
    }
}
