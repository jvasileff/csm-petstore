import com.vasileff.csmpetstore.domain {
    PSDomainObject
}
import com.vasileff.csmpetstore.mapper {
    Mapper
}

abstract
class BaseDao<DomainObject, PrimaryKey>(Mapper<DomainObject, PrimaryKey> mapper)
        satisfies PSDao<DomainObject, PrimaryKey>
        given DomainObject satisfies PSDomainObject<PrimaryKey>
        given PrimaryKey satisfies Comparable<PrimaryKey> {

    shared actual
    DomainObject? findByPK(PrimaryKey key)
        =>  mapper.findByPK(key);

    shared actual
    void insert(DomainObject obj)
        =>  mapper.insert(obj);

    shared actual
    void update(DomainObject obj)
        => mapper.update(obj);

    shared actual
    Integer delete(PrimaryKey key)
        => mapper.delete(key);

}
