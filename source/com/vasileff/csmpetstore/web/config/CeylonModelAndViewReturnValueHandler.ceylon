import ceylon.interop.java {
    javaClass
}

import com.vasileff.csmpetstore.web {
    ModelAndView
}

import org.springframework.core {
    MethodParameter
}
import org.springframework.web.context.request {
    NativeWebRequest
}
import org.springframework.web.method.support {
    HandlerMethodReturnValueHandler,
    ModelAndViewContainer
}

shared
class CeylonModelAndViewReturnValueHandler()
        satisfies HandlerMethodReturnValueHandler {

    shared actual
    void handleReturnValue(
            Object modelAndView,
            MethodParameter methodParameter,
            ModelAndViewContainer modelAndViewContainer,
            NativeWebRequest nativeWebRequest) {

        assert (is ModelAndView modelAndView);
        modelAndViewContainer.view = modelAndView.view;
        for (key->item in modelAndView.model) {
            modelAndViewContainer.addAttribute(key, item);
        }
    }

    shared actual
    Boolean supportsReturnType(MethodParameter methodParameter)
        =>  javaClass<ModelAndView>().isAssignableFrom(
                    methodParameter.parameterType);
}
