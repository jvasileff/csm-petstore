import org.springframework.security.web.authentication {
    SimpleUrlAuthenticationFailureHandler
}
import javax.servlet.http {
    HttpServletRequest,
    HttpServletResponse
}
import org.springframework.security.core {
    AuthenticationException
}

shared
class CsmAuthenticationFailureHandler(String defaultFailureUrl)
        extends SimpleUrlAuthenticationFailureHandler(defaultFailureUrl) {

    shared actual
    void onAuthenticationFailure(
            HttpServletRequest? request,
            HttpServletResponse? response,
            AuthenticationException? exception) {

        super.onAuthenticationFailure(request, response, exception);
        // TODO save entered username in session for display on new login form
    }
}
