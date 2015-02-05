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
    value storage = DomainObjectDelegate<DomainObjectType,PrimaryKey>(domainObjectInterface);

    shared actual
    Anything getAttribute(
            DomainObjectType? proxy,
            Attribute<DomainObjectType> attribute)
        => storage.get(attribute);

    shared actual
    void setAttribute(
            DomainObjectType? proxy,
            Attribute<DomainObjectType> attribute,
                Anything val)
        =>  storage.set(attribute, val);

    shared actual
    Anything invoke(
            DomainObjectType? proxy,
            Method<DomainObjectType> method,
            [Anything*] arguments) {

        if (method == `DomainObjectType.primaryKey`) {
            return storage.primaryKey;
        }
        else if (method == `DomainObjectType.isPrimaryKeySet`) {
            return storage.primaryKeySet;
        }
        else if (method == `DomainObjectType.isSet`) {
            assert (is {Attribute<DomainObjectType>*} properties = arguments.first);
            return storage.isSet(*properties);
        }
        else if (method == `DomainObjectType.isUpdated`) {
            assert (is {Attribute<DomainObjectType>*} properties = arguments.first);
            return storage.isUpdated(*properties);
        }
        else if (method == `DomainObjectType.clearUpdated`) {
            storage.clearUpdated();
            return null;
        }
        else {
            throw Exception ("unhandled method " + method.string);
        }
    }
}
