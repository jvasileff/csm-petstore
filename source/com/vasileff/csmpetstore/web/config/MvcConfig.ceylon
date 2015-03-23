import com.vasileff.jl4c.guava.collect {
    javaList
}

import java.lang {
    JBoolean=Boolean
}
import java.nio.charset {
    Charset
}
import java.util {
    JList=List
}

import org.springframework.context.annotation {
    configuration,
    componentScan,
    bean
}
import org.springframework.context.support {
    ResourceBundleMessageSource
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
import com.vasileff.csmpetstore.web {
    Model,
    MutableModel
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
            JList<HttpMessageConverter<out Object>> list) {

        value textConverter = StringHttpMessageConverter();
        textConverter.supportedMediaTypes = javaList {
            MediaType("text", "plain", Charset.forName("UTF-8"))};
        list.add(textConverter);

        value htmlConverter = StringHttpMessageConverter();
        htmlConverter.supportedMediaTypes = javaList {
            MediaType("text", "html", Charset.forName("UTF-8"))};
        list.add(htmlConverter);
    }

    shared actual
    void configurePathMatch(PathMatchConfigurer pathMatchConfigurer)
        // FIXME Ceylon integration problem for Booleans!
        =>  pathMatchConfigurer.setUseTrailingSlashMatch(JBoolean.\iFALSE);

    shared actual
    void addArgumentResolvers(JList<HandlerMethodArgumentResolver> list)
        =>  list.add(ceylonModelMapArgumentResolver());

    "Expose the model as a Ceylon `Map<String, Object>`."
    see(`alias Model`, `alias MutableModel`, `class CeylonModelArgumentResolver`)
    shared default bean
    HandlerMethodArgumentResolver ceylonModelMapArgumentResolver()
        =>  CeylonModelArgumentResolver();

    shared default bean
    ResourceBundleMessageSource messageSource() {
        ResourceBundleMessageSource rbms = ResourceBundleMessageSource();
        rbms.setBasename("com.vasileff.csmpetstore.terminology");
        return rbms;
    }

    /*
        Not sure if spring mvc support for non j.u.Collection
        collections is possible, but these may help:

        http://docs.spring.io/spring/docs/4.0.x/spring-framework-reference/html/validation.html#core-convert
        http://docs.spring.io/spring/docs/4.0.x/javadoc-api/org/springframework/beans/propertyeditors/CustomCollectionEditor.html
        http://forum.spring.io/forum/spring-projects/container/52265-custom-property-editor-with-generic-types
        https://github.com/spring-projects/spring-scala/wiki/Wiring-up-Scala-Collections-in-Spring-XML
     */
}
