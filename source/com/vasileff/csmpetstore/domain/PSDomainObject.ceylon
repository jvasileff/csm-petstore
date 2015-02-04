shared
interface PSDomainObject<out PrimaryKey>
        given PrimaryKey satisfies Comparable<PrimaryKey> {

    shared formal PrimaryKey? getPK();

}
