import com.vasileff.csmpetstore.support {
    CeylonStringMutableMap,
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
import ceylon.interop.java {
    CeylonMutableMap,
    CeylonMap
}

"Expose the model as a Ceylon `Map<String, Object>`."
see(`function MvcConfig.ceylonModelMapArgumentResolver`,
    `class ModelMethodProcessor`,
    `interface HandlerMethodArgumentResolver`,
    `interface HandlerMethodReturnValueHandler`)
class CeylonModelArgumentResolver() satisfies HandlerMethodArgumentResolver {
    // consider basing this on org.springframework.ui.Model instead of Map<>

    shared actual
    Object resolveArgument(
                MethodParameter methodParameter,
                ModelAndViewContainer modelAndViewContainer,
                NativeWebRequest nativeWebRequest,
                WebDataBinderFactory webDataBinderFactory)
        =>  if (methodParameter.parameterType.string == "interface ceylon.language.Map")
            then CeylonStringMap(CeylonMap(modelAndViewContainer.model))
            else CeylonStringMutableMap(CeylonMutableMap(modelAndViewContainer.model));

    shared actual
    Boolean supportsParameter(MethodParameter methodParameter)
        // fails with RuntimeException: given type has type arguments
        //=>  javaClass<Map<Nothing, Nothing>>()
        //        .isAssignableFrom(methodParameter.parameterType);
        =>  methodParameter.parameterType.string ==
                "interface ceylon.language.Map" ||
            methodParameter.parameterType.string ==
                "interface ceylon.collection.MutableMap";
}
