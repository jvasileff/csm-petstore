import ceylon.collection {
    HashMap,
    HashSet
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
        given DomainObject satisfies PSDomainObject<PK> & DO2<DomainObject>
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
            [Anything*] arguments) {

        if (method == `DomainObject.getPK`) {
            return storage.primaryKey;
        }
        else if (method == `DomainObject.primaryKeySet`) {
            // FIXME this cleanup belongs in the adapter
            return JBoolean(storage.primaryKeySet);
        }
        else if (method == `DomainObject.isSet`) {
            if (nonempty arguments) {
                assert (is {Attribute<DomainObject>*} properties = arguments.first);
                return JBoolean.valueOf(storage.isSet(*properties));
            }
            return JBoolean.valueOf(storage.isSet());
        }
        else if (method == `DomainObject.isUpdated`) {
            if (nonempty arguments) {
                assert (is {Attribute<DomainObject>*} properties = arguments.first);
                return JBoolean.valueOf(storage.isUpdated(*properties));
            }
            return JBoolean.valueOf(storage.isUpdated());            
        }
        else if (method == `DomainObject.clearUpdated`) {
            storage.clearUpdated();
            return null;
        }
        else {
            throw Exception ("unhandled method " + method.string);
        }
    }

}

class DomainObjectStorage<DomainObject, PK>(domainObjectInterface)
        given DomainObject satisfies PSDomainObject<PK>
        given PK satisfies Comparable<PK> {

    Interface<DomainObject> domainObjectInterface;

    shared
    alias Property => Attribute<DomainObject>;

    value propertyMap = HashMap<Property, Anything>();

    value updatedPropertySet = HashSet<Property>();

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
        updatedPropertySet.add(property);
        propertyMap.put(property, newValue);
    }

    shared
    Anything getProperty(Property property) {
        log.trace(() => "getting property " + property.string);
        checkIsField(property);
        checkDefined(property);
        return propertyMap[property];
    }

    shared
    Boolean primaryKeySet
        =>  propertyMap.defines(primaryKeyProperty);

    shared
    PK? primaryKey {
        assert (is PK? pk = getProperty(primaryKeyProperty));
        return pk;
    }

    shared
    Boolean isSet(Property* properties)
        =>  propertyMap.definesAny(properties);

    shared
    Boolean isUpdated(Property* properties)
        =>  updatedPropertySet.containsAny(properties);

    shared
    void clearUpdated()
        =>  updatedPropertySet.clear();

    void checkIsField(Property property) {
        if (property.declaration.annotations<FieldAnnotation>().empty) {
            throw Exception(property.declaration.name + " is not a field.");
        }
    }

    void checkDefined(Property property) {
        if (!propertyMap.defines(property)) {
            throw Exception(property.declaration.name + " has not been set.");
        }
    }
}

shared
DomainObject domainObject<DomainObject, PK>
        (Interface<DomainObject> domainObjectInterface)
        given DomainObject satisfies PSDomainObject<PK> & DO2<DomainObject>
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
    print(account.isSet(`Account2.username`));
    print(account.isSet(`Account2.username`, `Account2.email`));
    print(account.isSet(`Account2.email`));
    print(account.isSet());
    print(account.isUpdated());
    print(account.isUpdated(`Account2.username`));
    print(account.isUpdated(`Account2.username`, `Account2.email`));
    print(account.isUpdated(`Account2.email`));
    account.clearUpdated();
}
