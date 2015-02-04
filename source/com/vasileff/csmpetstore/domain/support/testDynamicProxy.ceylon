import ceylon.interop.java {
    javaClassFromInstance,
    javaClass,
    createJavaObjectArray
}

import java.lang.reflect {
    Proxy
}

shared
void testSimpleCI() {
    User user = UserImpl();
    value newValue = "newValu";
    user.username = "InitialUsername";

    value handler = SampleCeylonInvocationHandler(user);
    value userInterface = `User`;

    assert(exists usernameAttribute = userInterface.getAttribute<User>("username"));
    handler.setAttribute(null, usernameAttribute, "myUsername" of Anything);
    handler.setAttribute(null, usernameAttribute, newValue); // ceylon wraps in a ceylon string

    assert (exists result = handler.getAttribute(null, usernameAttribute));
    print(javaClassFromInstance(result));
    print("new value: " + user.username);

    assert(exists doSomething = userInterface.getMethod<User>("doSomething"));
    print(doSomething);
    print(handler.invoke(null, doSomething, ["this is the value"]));
    
    assert(exists echo = userInterface.getMethod<User>("echo", `Anything`));
    print(doSomething);
    print(handler.invoke(null, doSomething, ["echoing"]));
}

shared
void testing() {
    User user = UserImpl();
    value clazz = javaClass<User>();
    //value clazz = javaClassFromInstance(user);
    assert (is User proxy = Proxy.newProxyInstance(
        clazz.classLoader,
        createJavaObjectArray { clazz },
        InvocationHandlerAdapter(`User`, SampleCeylonInvocationHandler(user))));

    value nv = "John";
    proxy.fullName = nv;
    print(proxy.fullName);
}
