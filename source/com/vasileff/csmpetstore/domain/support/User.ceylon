import javax.validation.constraints {
    size=size__GETTER,
    pattern=pattern__GETTER
}

shared interface User satisfies DomainObject<String, User> {

    size { min=3; max=75; }
    pattern { regexp="(?U)[\\p{Alnum}\\p{gc=Pc}]*"; }
    shared variable formal primaryKey field
    String username;

    size { min=1; max=75; }
    shared variable formal field
    String? email;

    size { min=1; max=50; }
    shared variable formal field
    String fullName;

    size { max=50; }
    shared variable formal field
    String? country;

    shared variable formal field
    Boolean testBoolean;

    shared variable formal field
    Integer testInteger;

}
