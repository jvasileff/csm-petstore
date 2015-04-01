import ceylon.language.meta.model {
    Attribute,
    Method,
    Interface
}

import com.vasileff.proxy {
    InvocationHandler
}

shared
class DomainObjectInvocationHandler<DomainObjectType, PrimaryKey>()
        satisfies InvocationHandler<DomainObjectType>
        given DomainObjectType satisfies DomainObject<PrimaryKey, DomainObjectType> {

    assert (is Interface<DomainObjectType> domainObjectInterface = `DomainObjectType`);
    value delegate = DomainObjectDelegate<DomainObjectType,PrimaryKey>(domainObjectInterface);

    T assertType<T>(Anything o) {
        assert(is T o);
        return o;
    }

    shared actual
    Get getAttribute<Get, Set>(
            DomainObjectType proxy,
            Attribute<DomainObjectType, Get, Set> attribute)
        =>  if (attribute == `DomainObjectType.string`) then
                assertType<Get>(delegate.string)
            else if (attribute == `DomainObjectType.hash`) then
                assertType<Get>(delegate.hash)
            else
                assertType<Get>(delegate.get(attribute));

    shared actual
    void setAttribute<Get, Set>(
            DomainObjectType proxy,
            Attribute<DomainObjectType, Get, Set> attribute,
            Set val)
        =>  delegate.set(attribute, val);

    shared actual
    Type invoke<Type, Arguments>(
            DomainObjectType proxy,
            Method<DomainObjectType, Type, Arguments> method,
            Arguments arguments)
            given Arguments satisfies Anything[] {

        if (method == `DomainObjectType.primaryKey`) {
            return assertType<Type>(delegate.primaryKey());
        }
        else if (method == `DomainObjectType.isPrimaryKeySet`) {
            return assertType<Type>(delegate.primaryKeySet);
        }
        else if (method == `DomainObjectType.isSet`) {
            assert (is {Attribute<DomainObjectType>*} properties = arguments.first);
            return assertType<Type>(delegate.isSet(*properties));
        }
        else if (method == `DomainObjectType.isUpdated`) {
            assert (is {Attribute<DomainObjectType>*} properties = arguments.first);
            return assertType<Type>(delegate.isUpdated(*properties));
        }
        else if (method == `DomainObjectType.clearUpdated`) {
            delegate.clearUpdated();
            return assertType<Type>(null);
        }
        else if (method == `DomainObjectType.hash`) {
            return assertType<Type>(delegate.hashCode(proxy));
        }
        else if (method == `DomainObjectType.equals`) {
            return assertType<Type>(delegate.equalTo(proxy, arguments.first));
        }
        else if (method == `DomainObjectType.type`) {
            return assertType<Type>(delegate.type());
        }
        else {
            throw Exception ("Unhandled method ``method.string``.");
        }
    }
}
