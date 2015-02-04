import ceylon.collection {
    HashMap
}
import ceylon.interop.java {
    javaClass,
    createJavaObjectArray,
    javaClassFromInstance
}
import ceylon.language.meta.model {
    Interface
}

import java.lang {
    ObjectArray,
    JInteger=Integer
}
import java.lang.reflect {
    InvocationHandler,
    JMethod=Method,
    Proxy
}
import com.vasileff.csmpetstore.domain {
    PSDomainObject
}

shared
class JavaDomainObjectInvocationHandler() satisfies InvocationHandler {

    value properties = HashMap<String, Object?>();

    shared actual
    Object? invoke(
            Object proxy, JMethod method, ObjectArray<Object> args) {

        print(javaClassFromInstance(proxy));
        value methodName = method.name;
        if (methodName.startsWith("get")) {
            value property = methodName.spanFrom(3);
            if (properties.defines(property)) {
                return properties[method.name.spanFrom(3)];
            }
            else {
                throw Exception(property + " has not been set.");
            }
        }
        else if (methodName.startsWith("set")) {
            properties.put(method.name.spanFrom(3), args.get(0));
            return null;
        }
        else if (methodName == "hashCode") {
            return JInteger(this.hash);
        }
        return null;
    }
}

shared
DomainObject javaBasedDomainObject<DomainObject, PK>(Interface<DomainObject> i)
        given DomainObject satisfies PSDomainObject<PK>
        given PK satisfies Comparable<PK> {

    value clazz = javaClass<DomainObject>();
    assert (is DomainObject do = Proxy.newProxyInstance(
            clazz.classLoader,
            createJavaObjectArray { clazz },
            JavaDomainObjectInvocationHandler()));
    return do;
}
