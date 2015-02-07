import com.google.common.collect {
    ImmutableList {
        listOf=\iof
    }
}

import java.lang {
    JBoolean=Boolean
}
import java.nio.charset {
    Charset
}
import java.util {
    List
}

import org.springframework.context.annotation {
    configuration,
    componentScan,
    bean
}
import org.springframework.http {
    MediaType
}
import org.springframework.http.converter {
    HttpMessageConverter,
    StringHttpMessageConverter
}
import org.springframework.web.method.support {
    HandlerMethodArgumentResolver
}
import org.springframework.web.servlet.config.annotation {
    enableWebMvc,
    WebMvcConfigurerAdapter,
    ResourceHandlerRegistry,
    PathMatchConfigurer
}

componentScan({
    "com.vasileff.csmpetstore.web.view",
    "com.vasileff.csmpetstore.web.controller"
})
shared configuration enableWebMvc
class MvcConfig() extends WebMvcConfigurerAdapter() {

    // On using non-JDK collections: https://jira.spring.io/browse/SCALA-9

    shared actual
    void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");
        registry.setOrder(-1);
    }

    shared actual
    void configureMessageConverters(
            List<HttpMessageConverter<out Object>> list) {

        value textConverter = StringHttpMessageConverter();
        textConverter.supportedMediaTypes = listOf(
            MediaType("text", "plain", Charset.forName("UTF-8")));
        list.add(textConverter);

        value htmlConverter = StringHttpMessageConverter();
        htmlConverter.supportedMediaTypes = listOf(
            MediaType("text", "html", Charset.forName("UTF-8")));
        list.add(htmlConverter);
    }

    shared actual
    void configurePathMatch(PathMatchConfigurer pathMatchConfigurer)
        // FIXME Ceylon integration problem for Booleans!
        =>  pathMatchConfigurer.setUseTrailingSlashMatch(JBoolean.\iFALSE);

    shared actual
    void addArgumentResolvers(List<HandlerMethodArgumentResolver> list)
        =>  list.add(ceylonModelMapArgumentResolver());

    shared default bean
    HandlerMethodArgumentResolver ceylonModelMapArgumentResolver()
        =>  CeylonModelArgumentResolver();
}
