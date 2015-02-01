shared
interface PSDomainObject<PrimaryKey>
        given PrimaryKey satisfies Comparable<PrimaryKey> {

    shared formal
    PrimaryKey? getPK();

}