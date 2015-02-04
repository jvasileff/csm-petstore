import java.lang {
    JString=String
}

import ceylon.interop.java {
    javaString
}
import ceylon.language.meta.model {
    Attribute,
    Method
}

shared
class SampleCeylonInvocationHandler(User user)
        satisfies CeylonInvocationHandler<User> {

    shared actual
    Anything getAttribute(User? proxy,
                          Attribute<User> attribute) {
        print(attribute.declaration.annotations<Annotation>());
        return attribute.bind(user).get();
    }

    shared actual
    void setAttribute(User? proxy,
                      Attribute<User> attribute,
                      Anything val) {
        
        // The *actual* Java method may take a java.lang.String. And
        // we may actually have a java.lang.String. But... the Ceylon
        // type may be ceylon.language.String. Critically, "setIfAssignable"
        // expects the Ceylon type.
        //
        // So, sometimes we need to convert the "correct" type to the
        // "expected" type, and the runtime will perform the opposite
        // conversion (See AppliedValue.setIfAssignable, initSetter, and
        // MethodHandleUtil.unboxArguments.

        value valueModel = attribute.bind(user);
        Anything expectedValue;

        if (is JString val, valueModel.type.exactly(`String`)) {
            expectedValue = val.string; // convert to ceylon.language.String
        }
        else if (is String val, valueModel.type.string == "java.lang::String") {
            expectedValue = javaString(val); // will this ever happen?
        }
        else {
            expectedValue = val;
        }

        //assert(exists val);
        ////print(type(val)); // fails for j.l.String!
        //print("**** " + javaClassFromInstance(val).string);
        //print("vm="+valueModel.string);
        //print("vm.type="+valueModel.type.string);

        valueModel.setIfAssignable(expectedValue);
    }

    shared actual
    Anything invoke(User? proxy,
                    Method<User> method,
                    [Anything*] arguments) {
        print("arguments: ``arguments``");
        return method.bind(user).apply(*arguments);
    }

}
