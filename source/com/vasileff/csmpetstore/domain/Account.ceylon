import ceylon.language {
    CString=String
}

import javax.validation.constraints {
    size=size__GETTER,
    notNull=notNull__GETTER,
    pattern=pattern__GETTER
}
import com.vasileff.csmpetstore.domain.support {
    DomainObject,
    field,
    primaryKey,
    toString
}

shared
interface Account satisfies DomainObject<String, Account> {

    field primaryKey notNull
    toString(1)
    size { min=3; max=75; }
    pattern { regexp="(?U)[\\p{Alnum}\\p{gc=Pc}]*"; }
    shared variable formal
    String username;

    field
    toString(2)
    size { min=1; max=75; }
    shared variable formal
    String? email;

    field notNull
    toString(3)
    size { min=1; max=50; }
    shared variable formal
    String fullName;

    field
    size { max=50; }
    shared variable formal
    String? country;

    field
    shared variable formal
    Boolean testBoolean;

    field
    shared variable formal
    Integer testInteger;

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

    //shared actual
    //String? getPK()
    //    =>  username;

}
