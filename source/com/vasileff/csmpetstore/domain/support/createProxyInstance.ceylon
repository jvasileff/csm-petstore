import ceylon.interop.java {
    javaClass,
    createJavaObjectArray
}
import ceylon.language.meta.model {
    Interface
}

import java.lang.reflect {
    Proxy
}

shared
ProxyType createProxyInstance<ProxyType>
        (InvocationHandler<ProxyType> invocationHandler) 
        given ProxyType satisfies Object {

    assert (is Interface<ProxyType> interfaceModel = `ProxyType`);
    value clazz = javaClass<ProxyType>();
    assert (is ProxyType instance = Proxy.newProxyInstance(
        clazz.classLoader,
        createJavaObjectArray { clazz },
        InvocationHandlerAdapter(
            interfaceModel,
            invocationHandler)));
    return instance;
}
