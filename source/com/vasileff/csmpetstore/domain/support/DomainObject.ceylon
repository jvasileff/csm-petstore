import ceylon.language.meta.model {
    Attribute
}

shared interface DomainObject<out PrimaryKey, Other> of Other
        given Other satisfies DomainObject<PrimaryKey, Other> {

    //Compound primary keys should be tuples
    //Primary key annotatinos should have order #
    //Possibly expose primary keys as maps with string keys for mybatis
    // shared formal Map<String, Object> primaryKeyMap();

    shared formal PrimaryKey? primaryKey();

    shared formal Boolean isPrimaryKeySet();

    shared formal Boolean isSet(Attribute<Other>* property);

    shared formal void clearSet();

    shared formal Boolean isUpdated(Attribute<Other>* property);

    shared formal void clearUpdated();

    shared formal Set<Attribute<Other>> propertiesUpdated();

    shared formal Set<Attribute<Other>> propertiesSet();

    shared formal void updateFrom(Other that, {Attribute<Other>*} properties = {});

}
