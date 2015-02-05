import java.lang {
    Class
}

import org.apache.ibatis.reflection.factory {
    DefaultObjectFactory
}
import ceylon.logging {
    debug
}

shared
class ObjectFactory(Map<Class<out Object>, Object()> constructors)
        extends DefaultObjectFactory() {

    shared actual T create<T>(Class<T> clazz) given T satisfies Object {
        log.trace("Attempting to create ``clazz``");
        if (exists constructor = constructors[clazz]) {
            log.info("*** creating our own");
            return UnsafeUtil.cast<T>(constructor());
        } else {
            log.trace("Delegating to default factory for ``clazz``");
            return super.create(clazz);
        }
    }

}
