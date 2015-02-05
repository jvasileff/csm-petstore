import com.vasileff.csmpetstore.domain {
    PSDomainObject
}
import ceylon.language.meta.model {
    Interface
}

shared
DomainObject createDomainObject<DomainObject, PK>
        (Interface<DomainObject> domainObjectInterface)
        given DomainObject satisfies PSDomainObject<PK> & DO2<DomainObject>
        given PK satisfies Comparable<PK>
    =>  createProxyInstance(DomainObjectInvocationHandler<DomainObject, PK>());