import org.springframework.core {
    MethodParameter
}
import org.springframework.web.bind.support {
    WebDataBinderFactory
}
import org.springframework.web.context.request {
    NativeWebRequest
}
import org.springframework.web.method.support {
    HandlerMethodArgumentResolver,
    ModelAndViewContainer
}
import com.vasileff.csmpetstore.support {
    CeylonStringMap
}
import com.vasileff.csmpetstore.web {
    Model
}

class CeylonModelArgumentResolver() satisfies HandlerMethodArgumentResolver {

    // see Spring's ModelMethodProcessor implements
    // HandlerMethodArgumentResolver & HandlerMethodReturnValueHandler

    // consider basing this on org.springframework.ui.Model instead of Map<>

    shared actual
    Model resolveArgument(
                MethodParameter methodParameter,
                ModelAndViewContainer modelAndViewContainer,
                NativeWebRequest nativeWebRequest,
                WebDataBinderFactory webDataBinderFactory)
        =>  CeylonStringMap(modelAndViewContainer.model);

    shared actual
    Boolean supportsParameter(MethodParameter methodParameter)
        // javaClass<Map<Nothing,Nothing>>()
        // fails with "given type has type arguments"
        //return javaClass<Map<Nothing,Nothing>>()
        //        .isAssignableFrom(methodParameter.parameterType);
        =>  methodParameter.parameterType.string ==
                "interface ceylon.language.Map";

}
