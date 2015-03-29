import com.vasileff.csmpetstore.web {
    Model,
    MutableModel
}
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

import javax.annotation {
    postConstruct
}
import javax.inject {
    inject=inject__SETTER
}

import org.springframework.context.annotation {
    configuration,
    componentScan,
    bean
}
import org.springframework.context.support {
    ResourceBundleMessageSource
}
import org.springframework.format {
    FormatterRegistry
}
import org.springframework.http {
    MediaType
}
import org.springframework.http.converter {
    HttpMessageConverter,
    StringHttpMessageConverter
}
import org.springframework.web.accept {
    ContentNegotiationManager
}
import org.springframework.web.method.support {
    HandlerMethodArgumentResolver,
    HandlerMethodReturnValueHandler
}
import org.springframework.web.servlet {
    HandlerExceptionResolver
}
import org.springframework.web.servlet.config.annotation {
    enableWebMvc,
    WebMvcConfigurerAdapter,
    ResourceHandlerRegistry,
    PathMatchConfigurer
}
import org.springframework.web.servlet.mvc.annotation {
    ResponseStatusExceptionResolver
}
import org.springframework.web.servlet.mvc.method.annotation {
    ExceptionHandlerExceptionResolver,
    RequestMappingHandlerAdapter
}
import org.springframework.web.servlet.mvc.support {
    DefaultHandlerExceptionResolver
}

componentScan({
    "com.vasileff.csmpetstore.web.view",
    "com.vasileff.csmpetstore.web.controller"
})
shared configuration enableWebMvc
class MvcConfig() extends WebMvcConfigurerAdapter() {

    late inject
    ContentNegotiationManager contentNegotiationManager;

    late inject
    RequestMappingHandlerAdapter requestMappingHandlerAdapter;

    shared postConstruct
    void init() {
        // don't include model attributes on redirects. Per Spring docs:
        // "However, for new applications we recommend setting it to true"
        requestMappingHandlerAdapter.setIgnoreDefaultModelOnRedirect(true);
    }

    "Static resources, not secured."
    shared actual
    void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");
        registry.setOrder(-1);
    }

    "Support web data binding to Ceylon types."
    shared actual
    void addFormatters(FormatterRegistry formatterRegistry) {
        formatterRegistry.addConverter(CeylonBooleanConverter());
        formatterRegistry.addConverter(CeylonIntegerConverter());
    }

    "Only support UTF-8 text and html for
     [[org.springframework.web.bind.annotation::responseBody]]"
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
        =>  pathMatchConfigurer.setUseTrailingSlashMatch(JBoolean.\iFALSE);

    "Expose the model as a Ceylon `Map<String, Object>`.
     for [[org.springframework.web.bind.annotation::RequestMapping]]
     handler methods."
    shared actual
    void addArgumentResolvers(JList<HandlerMethodArgumentResolver> list)
        =>  list.add(ceylonModelMapArgumentResolver());

    "Expose the model as a Ceylon `Map<String, Object>`."
    see(`alias Model`, `alias MutableModel`, `class CeylonModelArgumentResolver`)
    shared default bean
    HandlerMethodArgumentResolver ceylonModelMapArgumentResolver()
        =>  CeylonModelArgumentResolver();

    "Support return of [[com.vasileff.csmpetstore.web::ModelAndView]]
     for [[org.springframework.web.bind.annotation::RequestMapping]]
     handler methods."
    shared actual
    void addReturnValueHandlers(JList<HandlerMethodReturnValueHandler> list)
        =>  list.add(ceylonModelAndViewReturnValueHandler());

    "Support return of [[com.vasileff.csmpetstore.web::ModelAndView]]."
    shared default bean
    HandlerMethodReturnValueHandler ceylonModelAndViewReturnValueHandler()
        =>  CeylonModelAndViewReturnValueHandler();

    "Support return of [[com.vasileff.csmpetstore.web::ModelAndView]]
     for [[org.springframework.web.bind.annotation::ExceptionHandler]]
     handler methods."
    shared actual
    void configureHandlerExceptionResolvers(
            JList<HandlerExceptionResolver> list) {
        // not so easy to customize exception
        // resolvers; attempting to duplicate
        // WebMvcConfigurationSupport.addDefaultHandlerExceptionResolvers
        // so we can add ceylonModelAndViewReturnValueHandler()
        list.add(exceptionHandlerExceptionResolver());
        list.add(ResponseStatusExceptionResolver());
        list.add(DefaultHandlerExceptionResolver());
    }

    "Support return of [[com.vasileff.csmpetstore.web::ModelAndView]]
     for [[org.springframework.web.bind.annotation::ExceptionHandler]]
     handler methods."
    shared default bean
    ExceptionHandlerExceptionResolver exceptionHandlerExceptionResolver() {
        // WebMvcConfigurationSupport.addDefaultHandlerExceptionResolvers
        // resolver.messageConverters ?
        value resolver = ExceptionHandlerExceptionResolver();
        resolver.contentNegotiationManager = contentNegotiationManager;
        resolver.customReturnValueHandlers = javaList {
            ceylonModelAndViewReturnValueHandler()
        };
        return resolver;
    }

    shared default bean
    ResourceBundleMessageSource messageSource() {
        ResourceBundleMessageSource rbms = ResourceBundleMessageSource();
        rbms.setBasename("com.vasileff.csmpetstore.terminology");
        return rbms;
    }

    /*
        Not sure if spring mvc support for non j.u.Collection
        collections is possible, but these may help:

        https://jira.spring.io/browse/SCALA-9
        http://docs.spring.io/spring/docs/4.0.x/spring-framework-reference/html/validation.html#core-convert
        http://docs.spring.io/spring/docs/4.0.x/javadoc-api/org/springframework/beans/propertyeditors/CustomCollectionEditor.html
        http://forum.spring.io/forum/spring-projects/container/52265-custom-property-editor-with-generic-types
        https://github.com/spring-projects/spring-scala/wiki/Wiring-up-Scala-Collections-in-Spring-XML
     */
}
