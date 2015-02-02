import ceylon.language {
    CString=String
}

import javax.validation.constraints {
    size=size__GETTER,
    notNull=notNull__GETTER,
    pattern=pattern__GETTER
}

shared class Account satisfies PSDomainObject<String> {

    shared
    new Account() {}

    size { min=3; max=75; }
    pattern { regexp="(?U)[\\p{Alnum}\\p{gc=Pc}]*"; }
    notNull late shared variable
    String username;

    size { min=1; max=75; }
    late shared variable
    String? email;

    size { min=1; max=50; }
    notNull late shared variable
    String fullName;

    size { max=50; }
    late shared variable String? country;

    //late shared variable String? status;
    //late shared variable String? address1;
    //late shared variable String? address2;
    //late shared variable String? city;
    //late shared variable String? state;
    //late shared variable String? zip;
    //late shared variable String? country;
    //late shared variable String? phone;
    //late shared variable String? favoriteCategoryId;
    //late shared variable String? languagePreference;
    //late shared variable Boolean? listOption;
    //late shared variable Boolean? bannerOption;
    //late shared variable String? bannerName;

    //shared actual // FIXME late init
    //String string
    //    =>  username else "null";

    shared actual
    String? getPK()
        =>  username;

}
