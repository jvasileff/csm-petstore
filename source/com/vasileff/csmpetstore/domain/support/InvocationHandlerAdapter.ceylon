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
    JInvocationHandler=InvocationHandler,
    JMethod=Method
}

shared
class InvocationHandlerAdapter<Container>(
        Interface<Container> containerInterface,
        InvocationHandler<Container> handler)
        satisfies JInvocationHandler {

    value models = HashMap<String, Attribute<Container>|Method<Container>>();

    for (attribute in containerInterface.getAttributes<Container>()) {
        value attributeName = attribute.declaration.name;
        if (attributeName == "hash") {
            models.put("hashCode", attribute);
        }
        else if (attributeName == "string") {
            models.put("toString", attribute);
        }
        else {
            value uppercased = attributeName[0:1].uppercased + attributeName[1...];
            models.put("get" + uppercased, attribute);
            if (attribute.declaration.variable) {
                models.put("set" + uppercased, attribute);        
            }
        }
    }

    for (method in containerInterface.getMethods<Container>()) {
        variable value methodName = method.declaration.name;
        if (method.parameterTypes.size == 0 &&
                (methodName.startsWith("get") ||
                 methodName.startsWith("is"))) {
            methodName = "$" + methodName;
        }
        else if (method.parameterTypes.size == 1 &&
                 methodName.startsWith("set")) {
            methodName = "$" + methodName;
        }
        log.trace(() => "Adding method " + methodName);
        models.put(methodName, method);
    }

    shared actual
    Object? invoke(Object proxy, JMethod method, ObjectArray<Object>? args) {
        // FIXME will this work? What about generic containers?
        assert(is Container proxy);

        value methodName = method.name;
        switch (model = models.get(methodName))
        case (is Attribute<Container>) {
            if (methodName.startsWith("get") ||
                    methodName == "hashCode" ||
                    methodName == "toString") {
                value rawResult = handler.getAttribute(proxy, model);
                return coerceToJava(method.returnType, rawResult);
            }
            else {
                assert (exists args);
                value newValue = coerceToCeylon(model.type, args.get(0));
                handler.setAttribute(proxy, model, newValue);
                return null;
            }
        }
        case (is Method<Container>) {
            value ceylonArgs = coerceArgumentsToCeylon(model.parameterTypes, args);
            value rawResult = handler.invoke(proxy, model, ceylonArgs);
            return coerceToJava(method.returnType, rawResult);
        }
        case (is Null) {
            throw Exception("unexpected method: " + methodName);
        }
    }

    Object? impartObjectness(Anything any) {
        assert (is Object? any);
        return any;
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
            else if (is Type<Sequential<Anything>> expectedType,
                     is Null item) then
                empty
            else
                item;

    Object? coerceToJava(JClass<out Object> expectedType, Anything item)
        =>  if (expectedType == javaClass<JString>(),
                is String item) then
                javaString(item)
            else if (expectedType == javaClass<JInteger>() ||
                     expectedType == JInteger.\iTYPE,
                     is Integer item) then
                JInteger.valueOf(item)
            else if (expectedType == javaClass<JBoolean>() ||
                     expectedType == JBoolean.\iTYPE,
                     is Boolean item) then
                JBoolean.valueOf(item)
            else
                impartObjectness(item);

    [Anything*] coerceArgumentsToCeylon(
            [Type<Anything>*] expectedTypes, ObjectArray<Object>? args)
        =>  if (nonempty expectedTypes)
            then [ for (i->expectedType in expectedTypes.indexed)
                    coerceToCeylon(
                        expectedType,
                        if (exists args)
                            then args.get(i)
                            else null) ]
            else [];
}