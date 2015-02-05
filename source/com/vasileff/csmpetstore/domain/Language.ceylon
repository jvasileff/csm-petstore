import com.vasileff.csmpetstore.domain.support {
    DomainObject,
    field,
    primaryKey,
    createDomainObject
}

shared
interface Language satisfies DomainObject<Integer, Language> {

    field primaryKey
    shared formal variable
    Integer id;

    field
    shared formal variable
    String? name;

}

shared
Language languageOf(Integer id, String name) {
    value result = createDomainObject(`Language`);
    result.id = id;
    result.name = name;
    return result;
}
