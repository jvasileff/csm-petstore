shared class Language satisfies SSDomainObject<Integer> {

    late shared variable Integer? id;
    late shared variable String? name;

    shared new Language() {}

    shared new Of(Integer id, String name) {
        this.id = id;
        this.name = name;
    }

    shared actual String string => "``id else "null"``, ``name else "null"``";

    shared actual Integer? getPK() => id;
}
