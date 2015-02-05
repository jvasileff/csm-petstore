import ceylon.language.meta.model {
    Attribute,
    Method,
    Interface
}
import ceylon.logging {
    Logger,
    logger
}

import com.vasileff.csmpetstore.domain {
    PSDomainObject
}

Logger log = logger(`package`);

shared
class DomainObjectInvocationHandler<DomainObject, PK>()
        satisfies InvocationHandler<DomainObject>
        given DomainObject satisfies PSDomainObject<PK> & DO2<DomainObject>
        given PK satisfies Comparable<PK> {

    assert (is Interface<DomainObject> domainObjectInterface = `DomainObject`);
    value storage = DomainObjectDelegate<DomainObject,PK>(domainObjectInterface);

    shared actual
    Anything getAttribute(
            DomainObject? proxy,
            Attribute<DomainObject> attribute)
        => storage.getProperty(attribute);

    shared actual
    void setAttribute(
            DomainObject? proxy,
            Attribute<DomainObject> attribute,
                Anything val)
        =>  storage.setProperty(attribute, val);

    shared actual
    Anything invoke(
            DomainObject? proxy,
            Method<DomainObject> method,
            [Anything*] arguments) {

        if (method == `DomainObject.getPK`) {
            return storage.primaryKey;
        }
        else if (method == `DomainObject.primaryKeySet`) {
            return storage.primaryKeySet;
        }
        else if (method == `DomainObject.isSet`) {
            assert (is {Attribute<DomainObject>*} properties = arguments.first);
            return storage.isSet(*properties);
        }
        else if (method == `DomainObject.isUpdated`) {
            assert (is {Attribute<DomainObject>*} properties = arguments.first);
            return storage.isUpdated(*properties);
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
