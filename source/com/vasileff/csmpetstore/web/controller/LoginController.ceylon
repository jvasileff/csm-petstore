import com.vasileff.csmpetstore.auth {
    Subject
}
import com.vasileff.csmpetstore.support {
    log
}
import com.vasileff.csmpetstore.web {
    MutableModel,
    urls,
    roles,
    loginBadCredentials,
    loginDisabled,
    loginError
}
import com.vasileff.csmpetstore.web.view {
    LoginView
}

import javax.inject {
    inject
}
import javax.servlet.http {
    HttpSession
}

import org.springframework.security.authentication {
    BadCredentialsException,
    DisabledException
}
import org.springframework.security.web {
    WebAttributes
}
import org.springframework.stereotype {
    controller
}
import org.springframework.web.bind.annotation {
    requestMapping,
    RequestMethod {
        get=\iGET
    },
    pathVariable
}
import org.springframework.web.servlet {
    View
}
import org.springframework.web.servlet.mvc.support {
    RedirectAttributes
}

shared controller inject
class LoginController(
        Subject subject,
        LoginView loginView) {

    shared
    requestMapping { \ivalue={"/login"}; method={get}; }
    View login(MutableModel model, HttpSession? session) {
        if (subject.authenticated && subject.hasAuthorization(roles.user)) {
            return redirect("/");
        }
        else if (exists session) {
            if (is Throwable throwable = session.getAttribute) {
                session.removeAttribute(WebAttributes.\iAUTHENTICATION_EXCEPTION);
                switch(throwable)
                case (is BadCredentialsException) {
                    model.put("loginError", loginBadCredentials);
                }
                case (is DisabledException) {
                    model.put("loginError", loginDisabled);
                }
                else {
                    log.error("Throwing unhandled exception while authenticating user");
                    throw throwable;
                }
            }
            // add model attribute for last attempted username
            // remove session attribute for last attempted username
        }
        return loginView;
    }

    shared
    requestMapping { \ivalue={"/login/{error}"}; method={get}; }
    View loginErrorHandler(
            RedirectAttributes attributes,
            pathVariable String error) {
        // TODO actually support errors in the view
        if (exists loginError = loginError(error)) {
            attributes.addFlashAttribute("loginError", loginError);
        }
        return redirect(urls.login);
    }
}
