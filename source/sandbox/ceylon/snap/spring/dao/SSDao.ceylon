import sandbox.ceylon.snap.spring.domain {
    SSDomainObject
}

shared interface SSDao<DomainObject, PrimaryKey>
        given DomainObject satisfies SSDomainObject<PrimaryKey>
        given PrimaryKey satisfies Comparable<PrimaryKey> {

    shared formal DomainObject? findByPK(PrimaryKey id);

    shared formal void insert(DomainObject obj);

    shared formal void update(DomainObject obj);

    shared formal Integer delete(PrimaryKey key);

}