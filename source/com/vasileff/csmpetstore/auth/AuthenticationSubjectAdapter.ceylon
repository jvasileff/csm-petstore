import org.springframework.security.core.context {
    SecurityContextHolder
}
import org.springframework.security.core {
    Authentication,
    GrantedAuthority
}
import com.vasileff.jl4c.guava.collect {
    ImmutableSet
}
import ceylon.interop.java {
    CeylonIterable
}
import org.springframework.security.core.userdetails {
    User
}

shared
class AuthenticationSubjectAdapter(
        authentication = SecurityContextHolder.context.authentication)
        satisfies Subject {

    Authentication? authentication;

    User? user
        =   if (is User u = authentication?.principal)
            then u
            else null;

    shared actual
    {String*} authorities
        =   if (exists authentication)
            then ImmutableSet(CeylonIterable(authentication.authorities)
                    .map(GrantedAuthority.authority))
            else emptySet;

    shared actual
    Boolean authenticated
        =   authentication?.authenticated else false;

    shared actual
    Boolean hasAuthorization(String authorization)
        =>  authorities.contains(authorization);

    shared actual
    String? username
        =   user?.username;
}
