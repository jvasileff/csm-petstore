import com.vasileff.csmpetstore.domain.support {
    DomainObject
}
import com.vasileff.csmpetstore.mapper {
    Mapper
}

abstract
class BaseDao<DomainObjectType, PrimaryKey>(Mapper<DomainObjectType, PrimaryKey> mapper)
        satisfies PSDao<DomainObjectType, PrimaryKey>
        given DomainObjectType satisfies DomainObject<PrimaryKey, DomainObjectType> {

    shared actual
    DomainObjectType? findByPK(PrimaryKey key)
        =>  mapper.findByPK(key);

    shared actual
    void insert(DomainObjectType obj)
        =>  mapper.insert(obj);

    shared actual
    void update(DomainObjectType obj)
        => mapper.update(obj);

    shared actual
    Integer delete(PrimaryKey key)
        => mapper.delete(key);

}
