import com.vasileff.csmpetstore.domain {
    PSDomainObject
}
import ceylon.language.meta.model {
    Interface
}

shared
DomainObjectType createDomainObject<DomainObjectType, PK>
        (Interface<DomainObjectType> domainObjectInterface)
        given DomainObjectType satisfies PSDomainObject<PK> & DO2<DomainObjectType>
        given PK satisfies Comparable<PK>
    =>  createProxyInstance(DomainObjectInvocationHandler<DomainObjectType, PK>());