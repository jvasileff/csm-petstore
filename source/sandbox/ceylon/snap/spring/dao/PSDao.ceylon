import sandbox.ceylon.snap.spring.domain {
    PSDomainObject
}

shared interface PSDao<DomainObject, PrimaryKey>
        given DomainObject satisfies PSDomainObject<PrimaryKey>
        given PrimaryKey satisfies Comparable<PrimaryKey> {

    shared formal DomainObject? findByPK(PrimaryKey id);

    shared formal void insert(DomainObject obj);

    shared formal void update(DomainObject obj);

    shared formal Integer delete(PrimaryKey key);

}