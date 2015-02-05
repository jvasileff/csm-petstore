import com.vasileff.csmpetstore.domain.support {
    DomainObject,
    field,
    primaryKey,
    createDomainObject
}
//shared
//class Language satisfies PSDomainObject<Integer> {
//
//    late shared variable Integer? id;
//    late shared variable String? name;
//
//    shared
//    new Language() {}
//
//    shared
//    new Of(Integer id, String name) {
//        this.id = id;
//        this.name = name;
//    }
//
//    shared actual
//    String string
//        =>  "``id else "null"``, ``name else "null"``";
//
//    shared actual
//    Integer? getPK()
//        =>  id;
//}

shared
interface Language satisfies DomainObject<Integer, Language> {

    field primaryKey
    shared formal variable Integer id;

    field
    shared formal variable String? name;

}

shared Language languageOf(Integer id, String name) {
    value result = createDomainObject(`Language`);
    result.id = id;
    result.name = name;
    return result;
}
