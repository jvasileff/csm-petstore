import com.vasileff.csmpetstore.support {
    CeylonStringMap
}
import com.vasileff.csmpetstore.web {
    Model
}

import org.springframework.core {
    MethodParameter
}
import org.springframework.web.bind.support {
    WebDataBinderFactory
}
import org.springframework.web.context.request {
    NativeWebRequest
}
import org.springframework.web.method.annotation {
    ModelMethodProcessor
}
import org.springframework.web.method.support {
    HandlerMethodArgumentResolver,
    ModelAndViewContainer,
    HandlerMethodReturnValueHandler
}

"Expose the model as a Ceylon `Map<String, Object>`."
see(`function MvcConfig.ceylonModelMapArgumentResolver`,
    `class ModelMethodProcessor`,
    `interface HandlerMethodArgumentResolver`,
    `interface HandlerMethodReturnValueHandler`)
class CeylonModelArgumentResolver() satisfies HandlerMethodArgumentResolver {
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
        // fails with RuntimeException: given type has type arguments
        //=>  javaClass<Map<Nothing, Nothing>>()
        //        .isAssignableFrom(methodParameter.parameterType);
        =>  methodParameter.parameterType.string ==
                "interface ceylon.language.Map";
}
