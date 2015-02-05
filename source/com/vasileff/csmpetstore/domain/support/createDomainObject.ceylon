import ceylon.language.meta.model {
    Interface
}

shared
DomainObjectType createDomainObject<DomainObjectType, PrimaryKey>
        (Interface<DomainObjectType> domainObjectInterface)
        given DomainObjectType satisfies DomainObject<PrimaryKey, DomainObjectType>
    =>  createProxyInstance(DomainObjectInvocationHandler<DomainObjectType, PrimaryKey>());