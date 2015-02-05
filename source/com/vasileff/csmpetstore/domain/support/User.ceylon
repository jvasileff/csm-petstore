import ceylon.language {
    CString=String
}
import ceylon.language.meta.model {
    Attribute
}

import com.vasileff.csmpetstore.domain {
    PSDomainObject
}

import javax.validation.constraints {
    size=size__GETTER,
    pattern=pattern__GETTER
}

shared interface DO2<DomainObject> {

    shared formal Boolean primaryKeySet();

    shared formal Boolean isSet(Attribute<DomainObject>* property);

    shared formal Boolean isUpdated(Attribute<DomainObject>* property);

    shared formal void clearUpdated();
}

shared interface Account2 satisfies PSDomainObject<String>, DO2<Account2> {

    size { min=3; max=75; }
    pattern { regexp="(?U)[\\p{Alnum}\\p{gc=Pc}]*"; }
    primaryKey
    shared variable formal field
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

    //shared actual // FIXME late init
    //String string
    //    =>  username else "null";

    //shared actual
    //String? getPK()
    //    =>  username;
    
//    shared formal Boolean primaryKeySet();
//    
//    shared formal Boolean isSet(Attribute<Account2>* property);
//
//    shared formal Boolean isUpdated(Attribute<Account2>* property);
//
//    shared formal void clearUpdated();

}
