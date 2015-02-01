import com.vasileff.csmpetstore.domain {
    PSDomainObject
}
shared
interface Mapper<DomainObject, PrimaryKey>
        given DomainObject satisfies PSDomainObject<PrimaryKey>
        given PrimaryKey satisfies Comparable<PrimaryKey> {

    shared formal
    DomainObject? findByPK(PrimaryKey key);

    shared formal
    Integer delete(PrimaryKey key);

    shared formal
    Integer create(DomainObject obj);

    shared formal
    Integer update(DomainObject obj);

    shared formal
    PrimaryKey insert(DomainObject obj);

}