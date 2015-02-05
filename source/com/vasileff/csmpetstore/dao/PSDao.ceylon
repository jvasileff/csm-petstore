import com.vasileff.csmpetstore.domain.support {
    DomainObject
}

shared
interface PSDao<DomainObjectType, PrimaryKey>
        given DomainObjectType satisfies DomainObject<PrimaryKey, DomainObjectType> {

    shared formal
    DomainObjectType? findByPK(PrimaryKey id);

    shared formal
    void insert(DomainObjectType obj);

    shared formal
    void update(DomainObjectType obj);

    shared formal
    Integer delete(PrimaryKey key);

}
