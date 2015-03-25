import ceylon.logging {
    logger,
    Logger
}

import com.vasileff.jl4c.guava.collect {
    javaSet
}

import org.springframework.security.core.authority {
    SimpleGrantedAuthority
}
import org.springframework.security.core.userdetails {
    UserDetailsService,
    UserDetails,
    User,
    UsernameNotFoundException
}
import org.springframework.stereotype {
    service
}
import com.vasileff.csmpetstore.web {
    roles
}

Logger log = logger(`package`);

shared service
class CsmUserDetailsService()
        satisfies UserDetailsService {

    shared actual
    UserDetails loadUserByUsername(String username) {
        log.debug("Loading user details for '``username``'.");
        if (username.shorterThan(2)) {
            log.debug("User '``username``' not found.");
            throw UsernameNotFoundException(username);
        }
        value authorities = javaSet { SimpleGrantedAuthority(roles.user) };
        return User(username, username, authorities);
    }
}
