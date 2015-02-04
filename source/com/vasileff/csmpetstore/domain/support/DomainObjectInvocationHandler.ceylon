import ceylon.collection {
    HashMap
}
import ceylon.interop.java {
    javaClass,
    createJavaObjectArray
}
import ceylon.language.meta.model {
    Attribute,
    Method,
    Interface
}

import com.vasileff.csmpetstore.domain {
    PSDomainObject
}

import java.lang.reflect {
    Proxy
}
import ceylon.logging {
    Logger,
    logger
}
import java.lang {
    JBoolean=Boolean
}

Logger log = logger(`package`);

shared
class DomainObjectInvocationHandler<DomainObject, PK>()
        satisfies CeylonInvocationHandler<DomainObject>
        given DomainObject satisfies PSDomainObject<PK>
        given PK satisfies Comparable<PK> {

    assert (is Interface<DomainObject> domainObjectInterface = `DomainObject`);
    value storage = DomainObjectStorage<DomainObject,PK>(domainObjectInterface);

    shared actual
    Anything getAttribute(
            DomainObject? proxy,
            Attribute<DomainObject> attribute) {
        return storage.getProperty(attribute);
    }

    shared actual
    void setAttribute(
            DomainObject? proxy,
            Attribute<DomainObject> attribute,
            Anything val) {
        storage.setProperty(attribute, val);
    }

    shared actual
    Anything invoke(
            DomainObject? proxy,
            Method<DomainObject> method,
            {Anything*} arguments) {
        if (method.declaration.name == "getPK") {
            return storage.primaryKey;
        }
        else if (method.declaration.name == "primaryKeySet") {
            // FIXME this cleanup belongs in the adapter
            return JBoolean(storage.primaryKeySet);
        }
        else {
            return nothing;
        }
    }

}

class DomainObjectStorage<DomainObject, PK>(domainObjectInterface)
        given DomainObject satisfies PSDomainObject<PK>
        given PK satisfies Comparable<PK> {

    Interface<DomainObject> domainObjectInterface;

    shared
    alias Property => Attribute<DomainObject>;

    value properties = HashMap<Property, Anything>();

    Attribute<DomainObject, PK, Nothing> primaryKeyProperty;

    if (nonempty candidates = domainObjectInterface
            .getAttributes<DomainObject, PK, Nothing>
                (`PrimaryKeyAnnotation`), candidates.size == 1) {
        primaryKeyProperty = candidates.first;
    } else {
        throw Exception(
            "Exactly one attribute must be annotated with `primaryKey`");
    }

    shared
    void setProperty(Property property, Anything newValue) {
        log.trace(() => "setting property " + property.string);
        checkIsField(property);
        properties.put(property, newValue);
    }

    shared
    Anything getProperty(Property property) {
        log.trace(() => "getting property " + property.string);
        checkIsField(property);
        checkDefined(property);
        return properties[property];
    }

    shared
    Boolean primaryKeySet
        =>  properties.defines(primaryKeyProperty);

    shared
    PK? primaryKey {
        assert (is PK? pk = getProperty(primaryKeyProperty));
        return pk;
    }

    void checkIsField(Property property) {
        if (property.declaration.annotations<FieldAnnotation>().empty) {
            throw Exception(property.declaration.name + " is not a field.");
        }
    }

    void checkDefined(Property property) {
        if (!properties.defines(property)) {
            throw Exception(property.declaration.name + " has not been set.");
        }
    }
}

shared
DomainObject domainObject<DomainObject, PK>
        (Interface<DomainObject> domainObjectInterface)
        given DomainObject satisfies PSDomainObject<PK>
        given PK satisfies Comparable<PK> {

    value clazz = javaClass<DomainObject>();
    assert (is DomainObject domainObject = Proxy.newProxyInstance(
        clazz.classLoader,
        createJavaObjectArray { clazz },
        InvocationHandlerAdapter(
            domainObjectInterface, 
            DomainObjectInvocationHandler<DomainObject, PK>())));
    return domainObject;
}

shared
void testDomainObject() {
    //User user = domainObject(`User`);
    //user.username = "jvasileff";
    //print(user.username);
    //
    //user.exNullableString1 = "exNullableString1";

    Account2 account = domainObject(`Account2`);
    print(account.primaryKeySet());
    account.username = "jvasileff";
    print(account.username);
    print(account.getPK());
}
