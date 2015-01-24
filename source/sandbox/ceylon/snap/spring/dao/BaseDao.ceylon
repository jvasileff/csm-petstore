import sandbox.ceylon.snap.spring.domain {
    SSDomainObject
}
import sandbox.ceylon.snap.spring.mapper {
    SSMapper
}

abstract class BaseDao<DomainObject, PrimaryKey>(
        SSMapper<DomainObject, PrimaryKey> mapper)
        satisfies SSDao<DomainObject, PrimaryKey>
        given DomainObject satisfies SSDomainObject<PrimaryKey>
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
