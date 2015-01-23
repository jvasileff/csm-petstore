shared interface SSDomainObject<PrimaryKey>
        given PrimaryKey satisfies Comparable<PrimaryKey> {

    shared formal PrimaryKey? getPK();

}