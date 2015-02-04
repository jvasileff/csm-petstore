import com.vasileff.csmpetstore.domain {
    PSDomainObject
}
import ceylon.language {
    CString=String
}

import javax.validation.constraints {
    size=size__GETTER,
    notNull=notNull__GETTER,
    pattern=pattern__GETTER
}

shared interface User satisfies PSDomainObject<Integer> {

    field shared variable formal String username;
    field shared variable formal String fullName;

    shared default String xn => "x";
    shared default String doSomething(String x) => x.uppercased;

    shared default T echo<T>(T t) => t;

    shared variable formal String? exNullableString1;
    field shared formal String? exNullableString2;
    field shared formal String exString;
    field shared formal Integer? exNullableInteger1;
    field shared formal Integer? exNullableInteger2;
    primaryKey field shared formal Integer exInteger;

    shared formal Array<String> exArrayString;
    shared formal Array<String>? exNullableArrayString;
    shared formal Array<Integer> exArrayInteger;
    shared formal Array<Integer>? exNullableArrayInteger;

}

shared interface User2 {
    shared formal variable String username2;
}

shared class UserImpl() satisfies User & User2 {
    shared actual variable String fullName = "";
    shared actual Integer? getPK() => null;
    shared actual variable String username = "";
    shared actual variable String username2 = "";

    shared actual variable String? exNullableString1 = "";
    shared actual String? exNullableString2 = null;
    shared actual String exString = "";
    shared actual Integer? exNullableInteger1 = 1;
    shared actual Integer? exNullableInteger2 = null;
    shared actual Integer exInteger = 1;
    
    shared actual Array<String> exArrayString = Array { "" };
    shared actual Array<String>? exNullableArrayString = null;
    shared actual Array<Integer> exArrayInteger = Array { 1 };
    shared actual Array<Integer>? exNullableArrayInteger = null;
}

shared interface Account2 satisfies PSDomainObject<String> {

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
    
    shared formal Boolean primaryKeySet();

}
