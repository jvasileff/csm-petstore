import com.google.common.collect {
    ImmutableList
}

import java.nio.charset {
    Charset
}
import java.util {
    List
}

import org.springframework.context.annotation {
    configuration,
    componentScan
}
import org.springframework.http {
    MediaType
}
import org.springframework.http.converter {
    HttpMessageConverter,
    StringHttpMessageConverter
}
import org.springframework.web.servlet.config.annotation {
    enableWebMvc,
    WebMvcConfigurerAdapter,
    ResourceHandlerRegistry
}

shared configuration enableWebMvc
componentScan({"sandbox.ceylon.snap.spring.web.controller"})
class MvcConfig() extends WebMvcConfigurerAdapter() {

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
        textConverter.supportedMediaTypes = ImmutableList<Nothing>.\iof(
            MediaType("text", "plain", Charset.forName("UTF-8")));
        list.add(textConverter);

        value htmlConverter = StringHttpMessageConverter();
        textConverter.supportedMediaTypes = ImmutableList<Nothing>.\iof(
            MediaType("text", "html", Charset.forName("UTF-8")));
        list.add(htmlConverter);
    }
}
