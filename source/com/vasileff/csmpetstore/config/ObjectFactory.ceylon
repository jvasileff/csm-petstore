import com.vasileff.csmpetstore.support {
    log
}

import java.lang {
    Class
}

import org.apache.ibatis.reflection.factory {
    DefaultObjectFactory
}

shared
class ObjectFactory(Map<Class<out Object>, Object()> constructors)
        extends DefaultObjectFactory() {

    shared actual T create<T>(Class<T> clazz) given T satisfies Object {
        if (exists constructor = constructors[clazz]) {
            log.trace("Creating '{}' using factory", clazz);
            return UnsafeUtil.cast<T>(constructor());
        } else {
            log.trace("Delegating to default factory for '{}'", clazz);
            return super.create(clazz);
        }
    }

}
