import com.vasileff.csmpetstore.domain.support {
    DomainObject
}

shared
interface Mapper<DomainObjectType, PrimaryKey>
        given DomainObjectType satisfies DomainObject<PrimaryKey, DomainObjectType> {

    shared formal
    DomainObjectType? findByPK(PrimaryKey key);

    shared formal
    Integer delete(PrimaryKey key);

    shared formal
    Integer create(DomainObjectType obj);

    shared formal
    Integer update(DomainObjectType obj);

    shared formal
    PrimaryKey insert(DomainObjectType obj);

}