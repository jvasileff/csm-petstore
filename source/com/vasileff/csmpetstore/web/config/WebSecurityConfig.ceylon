import com.vasileff.csmpetstore.web {
    urls,
    loginParameters,
    roles
}

import org.springframework.context.annotation {
    configuration,
    bean
}
import org.springframework.security.config.annotation.web.builders {
    WebSecurity,
    HttpSecurity
}
import org.springframework.security.config.annotation.web.configuration {
    WebSecurityConfigurerAdapter
}
import org.springframework.security.config.annotation.web.servlet.configuration {
    enableWebMvcSecurity
}
import org.springframework.security.core.session {
    SessionRegistry,
    SessionRegistryImpl
}
import org.springframework.security.web.authentication {
    AuthenticationSuccessHandler,
    AuthenticationFailureHandler
}
import com.vasileff.csmpetstore.auth {
    CsmAuthenticationFailureHandler,
    CsmAuthenticationSuccessHandler,
    CsmAuthenticationSuccessListener,
    CsmAuthenticationFailureListener,
    CsmSessionDestroyedListener
}
import org.springframework.http {
    HttpMethod
}
import org.springframework.security.web.util.matcher {
    AntPathRequestMatcher
}

shared
configuration enableWebMvcSecurity
class WebSecurityConfig()
        extends WebSecurityConfigurerAdapter() {

    shared actual
    void configure(WebSecurity webSecurity) {
        webSecurity.ignoring().antMatchers(
            "/robots.txt",
            "/favicon.ico",
            "/resources/**");
    }

    shared actual
    void configure(HttpSecurity httpSecurity) {
        // TODO additional csrf configs
        // TODO remove non-fluent workaround for
        // https://github.com/ceylon/ceylon-spec/issues/1266

        httpSecurity.authorizeRequests()
            .filterSecurityInterceptorOncePerRequest(true);

        httpSecurity.authorizeRequests()
            .antMatchers(urls.login).permitAll()
            .antMatchers(urls.login + "/**").permitAll()
            .antMatchers(urls.status403Forbidden).permitAll()
            .antMatchers(urls.status404NotFound).permitAll()
            .antMatchers(urls.status500InternalServerError).permitAll()
            .antMatchers(urls.status999Default).permitAll()
            .anyRequest().hasAuthority(roles.user);

        httpSecurity
            .sessionManagement()
                .sessionFixation().newSession() // don't migrateSessionAttributes
                .maximumSessions(1) // one session per user
                    .maxSessionsPreventsLogin(false)
                    .expiredUrl(urls.loginConcurrent)
                    .sessionRegistry(sessionRegistry()) // workaround spring bug
                    .and()
                .and()
            .formLogin()
                .loginPage(urls.login)
                .loginProcessingUrl(urls.securityCheck)
                .usernameParameter(loginParameters.username)
                .passwordParameter(loginParameters.password)
                .successHandler(authenticationSuccessHandler())
                .failureHandler(authenticationFailureHandler())
                .and()
            .logout()
                .logoutUrl(urls.logout)
                .invalidateHttpSession(true)
                .logoutSuccessUrl(urls.logoutSuccess)
                .and()
            .exceptionHandling()
                .accessDeniedPage(urls.status403Forbidden);

        // For now, support GET logouts
        httpSecurity.logout().logoutRequestMatcher(
            AntPathRequestMatcher(urls.logout, HttpMethod.\iGET.string));
    }

    shared default bean
    SessionRegistry sessionRegistry()
        =>  SessionRegistryImpl();

    shared default bean
    AuthenticationSuccessHandler authenticationSuccessHandler()
        =>  CsmAuthenticationSuccessHandler();

    shared default bean
    AuthenticationFailureHandler authenticationFailureHandler()
        =>  CsmAuthenticationFailureHandler(urls.logout);

    shared default bean
    CsmAuthenticationSuccessListener authenticationSuccessListener()
        =>  CsmAuthenticationSuccessListener();

    shared default bean
    CsmAuthenticationFailureListener authenticationFailureListener()
        =>  CsmAuthenticationFailureListener();

    shared default bean
    CsmSessionDestroyedListener sessionDestroyedListener()
        =>  CsmSessionDestroyedListener();
}
