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
import com.vasileff.csmpetstore.config {
    UnsafeUtil
}
import com.vasileff.proxy {
    InvocationHandler
}

shared
ProxyType createProxyInstance<ProxyType>
        (InvocationHandler<ProxyType> invocationHandler)
        given ProxyType satisfies Object {

    assert (is Interface<ProxyType> interfaceModel = `ProxyType`);
    value clazz = javaClass<ProxyType>();

    // unsafe cast since assert(is ProxyType ...) results in
    // com.redhat.ceylon.compiler.loader.ModelResolutionException: Failed to resolve com.sun.proxy.$Proxy109
    return UnsafeUtil.cast<ProxyType>(
        Proxy.newProxyInstance(
            clazz.classLoader,
            createJavaObjectArray { clazz },
            InvocationHandlerAdapter(
                interfaceModel,
                invocationHandler)));
}
