import org.springframework.web.servlet.view {
    RedirectView
}
import javax.servlet {
    RequestDispatcher
}
import javax.servlet.http {
    HttpServletRequest
}
import com.google.common.base {
    Throwables
}

RedirectView redirect(String url)
    =>  RedirectView(url, true);

String? requestPathFor(HttpServletRequest? request) {
    if (exists request) {
        String servletPath;
        String pathInfo;
        if (is String path = request.getAttribute(
                RequestDispatcher.\iFORWARD_SERVLET_PATH)) {
            servletPath = path;
            pathInfo = request.getAttribute(
                RequestDispatcher.\iFORWARD_PATH_INFO)?.string else "";
        }
        else {
            servletPath = request.servletPath;
            pathInfo = request.pathInfo else "";
        }
        return servletPath + pathInfo;
    }
    else {
        return null;
    }
}

String? stackTraceAsString(Throwable? throwable)
    =>  if (exists throwable)
        then Throwables.getStackTraceAsString(throwable)
        else null;
