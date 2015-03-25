import java.lang {
    JInteger=Integer
}
import org.springframework.core.annotation {
    order
}
import org.springframework.security.web.context {
    AbstractSecurityWebApplicationInitializer
}
import javax.servlet {
    SessionTrackingMode
}
import java.util {
    JSet=Set
}
import com.vasileff.jl4c.guava.collect {
    javaSet
}

shared
order(JInteger.\iMAX_VALUE) // so our filters run last
class WebSecurityInitializer()
        extends AbstractSecurityWebApplicationInitializer() {

    "Enable to support user limit session management and
     session destroyed listeners."
    shared actual
    Boolean enableHttpSessionEventPublisher()
        =>  true;

    shared actual
    JSet<SessionTrackingMode> sessionTrackingModes
        =>  javaSet { SessionTrackingMode.\iCOOKIE };
}
