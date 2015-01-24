import sandbox.ceylon.snap.spring.domain {
    PSDomainObject
}
import sandbox.ceylon.snap.spring.mapper {
    PSMapper
}

abstract class BaseDao<DomainObject, PrimaryKey>(
        PSMapper<DomainObject, PrimaryKey> mapper)
        satisfies PSDao<DomainObject, PrimaryKey>
        given DomainObject satisfies PSDomainObject<PrimaryKey>
        given PrimaryKey satisfies Comparable<PrimaryKey> {

    shared actual DomainObject? findByPK(PrimaryKey key)
        =>  mapper.findByPK(key);

    shared actual void insert(DomainObject obj)
        =>  mapper.insert(obj);

    shared actual void update(DomainObject obj)
        => mapper.update(obj);

    shared actual Integer delete(PrimaryKey key)
        => mapper.delete(key);

}
