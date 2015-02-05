import com.vasileff.csmpetstore.domain.support {
    DomainObject,
    field,
    primaryKey,
    createDomainObject,
    toString
}

shared
interface Language satisfies DomainObject<Integer, Language> {

    field primaryKey toString
    shared formal variable
    Integer id;

    field  toString
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
