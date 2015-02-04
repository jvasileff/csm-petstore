import ceylon.collection {
    HashMap
}
import ceylon.interop.java {
    javaString,
    javaClass
}
import ceylon.language.meta.model {
    Interface,
    Attribute,
    Method,
    Type
}

import java.lang {
    JString=String,
    JInteger=Integer,
    JBoolean=Boolean,
    JClass=Class,
    ObjectArray
}
import java.lang.reflect {
    InvocationHandler,
    JMethod=Method
}

shared
class InvocationHandlerAdapter<Container>(
        Interface<Container> containerInterface,
        CeylonInvocationHandler<Container> handler)
        satisfies InvocationHandler {

    value models = HashMap<String, Attribute<Container>|Method<Container>>();

    for (attribute in containerInterface.getAttributes<Container>()) {
        // TODO: translate hashCode -> hash and toString -> string
        value attributeName = attribute.declaration.name;
        value uppercased = attributeName[0:1].uppercased + attributeName[1...];
        models.put("get" + uppercased, attribute);
        if (attribute.declaration.variable) {
            models.put("set" + uppercased, attribute);        
        }
    }

    for (method in containerInterface.getMethods<Container>()) {
        variable value methodName = method.declaration.name;
        if (methodName.startsWith("get") || methodName.startsWith("set")) {
            methodName = "$" + methodName;
        }
        log.trace(() => "Adding method " + methodName);
        models.put(methodName, method);
    }

    shared actual
    Object? invoke(Object proxy, JMethod method, ObjectArray<Object> args) {
        // FIXME will this work? What about generic containers?
        assert(is Container proxy);

        value methodName = method.name;
        switch (model = models.get(methodName))
        case (is Attribute<Container>) {
            if (methodName.startsWith("get")) {
                assert(is Object? rawResult = handler.getAttribute(proxy, model));
                value result = coerceToJava(method.returnType, rawResult);
                return result;
            }
            else {
                value newValue = coerceToCeylon(model.type, args.get(0));
                handler.setAttribute(proxy, model, newValue);
                return null;
            }
        }
        case (is Method<Container>) {
            // FIXME Type translations
            assert (is Object? result = handler.invoke(proxy, model, args.array));
            return result;
        }
        case (is Null) {
            throw Exception("unexpected method: " + methodName);
        }
    }
}

Object? coerceToCeylon(Type<Anything> expectedType, Object? item)
    =>  if (is Type<String> expectedType,
            is JString item) then
            item.string
        else if (is Type<Integer> expectedType,
                 is JInteger item) then
            item.longValue()
       else if (is Type<Boolean> expectedType,
                 is JBoolean item) then
            item.booleanValue()
        else
            item;

Object? coerceToJava(JClass<out Object> expectedType, Object? item)
    =>  if (expectedType == javaClass<JString>(),
            is String item) then
            javaString(item)
        else if (expectedType == javaClass<JInteger>(),
                 is Integer item) then
            JInteger.valueOf(item)
        else if (expectedType == javaClass<JBoolean>(),
                 is Boolean item) then
            JBoolean.valueOf(item)
        else
            item;
