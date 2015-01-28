import org.springframework.context.annotation {
    configuration,
    componentScan
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

}
