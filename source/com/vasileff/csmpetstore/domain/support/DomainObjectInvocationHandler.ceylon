import ceylon.language.meta.model {
    Attribute,
    Method,
    Interface
}
import ceylon.logging {
    Logger,
    logger
}

Logger log = logger(`package`);

shared
class DomainObjectInvocationHandler<DomainObjectType, PrimaryKey>()
        satisfies InvocationHandler<DomainObjectType>
        given DomainObjectType satisfies DomainObject<PrimaryKey, DomainObjectType> {

    assert (is Interface<DomainObjectType> domainObjectInterface = `DomainObjectType`);
    value delegate = DomainObjectDelegate<DomainObjectType,PrimaryKey>(domainObjectInterface);

    shared actual
    Anything getAttribute(
            DomainObjectType proxy,
            Attribute<DomainObjectType> attribute)
        =>  if (attribute == `DomainObjectType.string`) then
                delegate.string
            else if (attribute == `DomainObjectType.hash`) then
                delegate.hash
            else
                delegate.get(attribute);

    shared actual
    void setAttribute(
            DomainObjectType proxy,
            Attribute<DomainObjectType> attribute,
                Anything val)
        =>  delegate.set(attribute, val);

    shared actual
    Anything invoke(
            DomainObjectType proxy,
            Method<DomainObjectType> method,
            [Anything*] arguments) {

        if (method == `DomainObjectType.primaryKey`) {
            return delegate.primaryKey();
        }
        else if (method == `DomainObjectType.isPrimaryKeySet`) {
            return delegate.primaryKeySet;
        }
        else if (method == `DomainObjectType.isSet`) {
            assert (is {Attribute<DomainObjectType>*} properties = arguments.first);
            return delegate.isSet(*properties);
        }
        else if (method == `DomainObjectType.isUpdated`) {
            assert (is {Attribute<DomainObjectType>*} properties = arguments.first);
            return delegate.isUpdated(*properties);
        }
        else if (method == `DomainObjectType.clearUpdated`) {
            delegate.clearUpdated();
            return null;
        }
        else if (method == `DomainObjectType.hash`) {
            return delegate.hashCode(proxy);
        }
        else if (method == `DomainObjectType.equals`) {
            return delegate.equalTo(proxy, arguments.first);
        }
        else if (method == `DomainObjectType.type`) {
            return delegate.type();
        }
        else {
            throw Exception ("Unhandled method ``method.string``.");
        }
    }
}
