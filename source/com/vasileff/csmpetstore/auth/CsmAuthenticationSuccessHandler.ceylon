import org.springframework.security.web.authentication {
    SavedRequestAwareAuthenticationSuccessHandler
}
import javax.servlet.http {
    HttpServletRequest,
    HttpServletResponse
}
import org.springframework.security.core {
    Authentication
}

shared
class CsmAuthenticationSuccessHandler()
        extends SavedRequestAwareAuthenticationSuccessHandler() {

    shared actual
    void onAuthenticationSuccess(
            HttpServletRequest? request,
            HttpServletResponse? response,
            Authentication? authentication) {

        super.onAuthenticationSuccess(request, response, authentication);
        // TODO remove temporary authentication attributes from the session
    }
}