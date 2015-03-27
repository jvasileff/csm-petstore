import com.vasileff.csmpetstore.web {
    ModelAndView,
    NotFoundException
}
import com.vasileff.csmpetstore.web.view {
    ExceptionView,
    ErrorView,
    NotFoundView
}

import javax.inject {
    inject=inject__CONSTRUCTOR
}
import javax.servlet {
    RequestDispatcher
}
import javax.servlet.http {
    HttpServletRequest,
    HttpServletResponse
}

import org.springframework.http {
    HttpStatus
}
import org.springframework.security.access {
    AccessDeniedException
}
import org.springframework.security.web {
    WebAttributes
}
import org.springframework.stereotype {
    controller
}
import org.springframework.web.bind.annotation {
    requestMapping,
    responseStatus,
    exceptionHandler,
    controllerAdvice
}
import org.springframework.web.servlet.mvc.multiaction {
    NoSuchRequestHandlingMethodException
}

shared controller inject
class ErrorController(
        ExceptionView exceptionView,
        ErrorView errorView,
        ErrorControllerAdvice errorControllerAdvice) {

    "Serve default error page configured in `web.xml`."
    shared requestMapping({"/999"})
    ModelAndView defaultError(
            HttpServletRequest request,
            HttpServletResponse response) {

        log.debug("Request to /999");

        assert(is Throwable? throwable = request.getAttribute(
                RequestDispatcher.\iERROR_EXCEPTION));

        value httpStatusCode = response.status;
        value requestPath = requestPathFor(request) else "unknown path";
        value stackTrace = stackTraceAsString(throwable);

        log.error("Error while serving request for " +
                  "'``sanitizeForLog(requestPath)``', " +
                  "HTTP Status code ``httpStatusCode``", throwable);

        value mav = ModelAndView(errorView);
        mav.model.put("httpStatus", httpStatusCode);
        if (exists stackTrace) {
            mav.model.put("stackTrace", stackTrace);
        }
        return mav;
    }

    "Serve the 500 error page configured in `web.xml`."
    shared requestMapping({"/500"})
    responseStatus(HttpStatus.\iINTERNAL_SERVER_ERROR)
    ModelAndView internalServerError(HttpServletRequest request) {
        log.debug("Request to /500");
        assert(is Throwable? throwable = request.getAttribute(
                RequestDispatcher.\iERROR_EXCEPTION));

        return errorControllerAdvice.error(throwable, request);
    }

    "Serve the 403 error page configured in `web.xml`."
    shared requestMapping({"/403"})
    responseStatus(HttpStatus.\iFORBIDDEN)
    ModelAndView forbidden(HttpServletRequest request) {
        log.debug("Request to /403");
        assert (is Throwable? throwable =
            // due to a spring security exception
            request.getAttribute(WebAttributes.\iACCESS_DENIED_403) else
            // unlikely, but perhaps forwarded by the Servlet container
            request.getAttribute(RequestDispatcher.\iERROR_EXCEPTION));

        return errorControllerAdvice.forbidden(throwable, request);
    }

    "Serve the 404 error page configured in `web.xml`."
    shared requestMapping({"/404"})
    responseStatus(HttpStatus.\iNOT_FOUND)
    ModelAndView notFound(HttpServletRequest request) {
        log.debug("Request to /404 or unmatched /**");
        return errorControllerAdvice.notFound(null, request);
    }

    "Default mapping to prevent DispatcherServlet from spewing
     warn level log messages."
    shared requestMapping({"/**"})
    responseStatus(HttpStatus.\iNOT_FOUND)
    ModelAndView default(HttpServletRequest request) {
        log.debug("Request to /404 or unmatched /**");
        return errorControllerAdvice.notFound(null, request);
    }
}

shared controllerAdvice inject
class ErrorControllerAdvice(
        ExceptionView exceptionView,
        NotFoundView notFoundView) {

    shared exceptionHandler
    responseStatus(HttpStatus.\iINTERNAL_SERVER_ERROR)
    ModelAndView error(
            Throwable? throwable,
            HttpServletRequest request) {

        value requestPath = requestPathFor(request) else "unknown path";
        value stackTrace = stackTraceAsString(throwable);

        log.error("Error while serving request for " +
                  "'``sanitizeForLog(requestPath)``', " +
                  "sending INTERNAL_SERVER_ERROR to the client", throwable);

        value mav = ModelAndView(exceptionView);
        mav.model.put("errorMessageKey", "screen.exception.500");
        if (exists stackTrace) {
            mav.model.put("stackTrace", stackTrace);
        }
        return mav;
    }

    shared
    exceptionHandler({`class AccessDeniedException`})
    responseStatus(HttpStatus.\iFORBIDDEN)
    ModelAndView forbidden(
            Throwable? throwable,
            HttpServletRequest request) {

        value requestPath = requestPathFor(request) else "unknown path";
        value stackTrace = stackTraceAsString(throwable);

        log.info("Access Denied while serving request for " +
                 "'``sanitizeForLog(requestPath)``', " +
                 "sending FORBIDDEN to the client", throwable);

        value mav = ModelAndView(exceptionView);
        mav.model.put("errorMessageKey", "screen.exception.403");
        if (exists stackTrace) {
            mav.model.put("stackTrace", stackTrace);
        }
        return mav;
    }

    shared
    exceptionHandler({
        `class NoSuchRequestHandlingMethodException`,
        `class NotFoundException` })
    responseStatus(HttpStatus.\iNOT_FOUND)
    ModelAndView notFound(
            Throwable? throwable,
            HttpServletRequest request) {

        value requestPath = requestPathFor(request) else "unknown path";

        log.debug("Returning error-not-found for " +
                  "'``sanitizeForLog(requestPath)``'", throwable);
        return ModelAndView(notFoundView);
    }
}

shared controller
class ErrorControllerTestPages() {

    shared requestMapping({"/test-exception"})
    void testException() {
        throw Exception("Testing...");
    }

    shared requestMapping({"/test-access-denied-exception"})
    void testAccessDeniedException() {
        throw AccessDeniedException("Testing...");
    }

    shared requestMapping({"/test-not-found-exception"})
    void testNotFoundException() {
        throw NotFoundException("Testing...");
    }

    shared requestMapping({"/test-assertion-error"})
    void testAssertionError() {
        throw AssertionError("Testing...");
    }

    shared requestMapping({"/test-forbidden-response"})
    void testForbiddenResponse(HttpServletResponse response) {
        response.sendError(HttpServletResponse.\iSC_FORBIDDEN);
    }

    shared requestMapping({"/test-not-found-response"})
    void testNotFoundResponse(HttpServletResponse response) {
        response.sendError(HttpServletResponse.\iSC_NOT_FOUND);
    }

    shared requestMapping({"/test-internal-server-error-response"})
    void testInternalServerErrorResponse(HttpServletResponse response) {
        response.sendError(HttpServletResponse.\iSC_INTERNAL_SERVER_ERROR);
    }

    shared requestMapping({"/test-expectation-failed-response"})
    void testExpectationFailedResponse(HttpServletResponse response) {
        response.sendError(HttpServletResponse.\iSC_EXPECTATION_FAILED);
    }
}
