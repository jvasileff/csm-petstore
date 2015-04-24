import com.vasileff.csmpetstore.auth {
    CsmUserDetailsService,
    Subject,
    AuthenticationSubjectAdapter
}
import com.vasileff.csmpetstore.config {
    AppConfig
}
import com.vasileff.jl4c.guava.collect {
    javaList
}

import javax.servlet {
    Filter
}

import org.springframework.context.annotation {
    configuration,
    bean,
    importConfiguration=\iimport,
    scope,
    ScopedProxyMode
}
import org.springframework.security.authentication {
    AuthenticationProvider,
    AuthenticationManager,
    ProviderManager,
    AuthenticationEventPublisher,
    DefaultAuthenticationEventPublisher
}
import org.springframework.security.authentication.dao {
    DaoAuthenticationProvider
}
import org.springframework.security.core.userdetails {
    UserDetailsService
}
import org.springframework.web.context {
    WebApplicationContext
}
import org.springframework.web.filter {
    HiddenHttpMethodFilter,
    CharacterEncodingFilter,
    CompositeFilter
}

configuration shared
importConfiguration({`AppConfig`, `WebSecurityConfig`})
class WebAppConfig() {

    shared default bean {name={"webAppFilters"};}
    Filter webAppFilters() {
        value compositeFilter = CompositeFilter();
        compositeFilter.setFilters(
            javaList {
                characterEncodingFilter(),
                hiddenHttpMethodFilter()
            });
        return compositeFilter;
    }

    shared default bean
    Filter characterEncodingFilter() {
        value filter = CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        return filter;
    }

    shared default bean
    Filter hiddenHttpMethodFilter()
        =>  HiddenHttpMethodFilter();

    // Authentication

    shared default
    bean { name={"org.springframework.security.authenticationManager"}; }
    AuthenticationManager authenticationManager() {
        value manager = ProviderManager(javaList { authenticationProvider() });
        manager.setAuthenticationEventPublisher(authenticationEventPublisher());
        return manager;
    }

    shared default bean
    AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService());
        //provider.setPasswordEncoder(passwordEncoder());
        return provider;
    }

    shared default bean
    UserDetailsService userDetailsService()
        =>  CsmUserDetailsService();

    shared default bean
    AuthenticationEventPublisher authenticationEventPublisher()
        =>  DefaultAuthenticationEventPublisher();

    shared default bean
    scope {
        WebApplicationContext.\iSCOPE_REQUEST;
        proxyMode = ScopedProxyMode.\iINTERFACES;
    }
    Subject subject()
        =>  AuthenticationSubjectAdapter();
}
