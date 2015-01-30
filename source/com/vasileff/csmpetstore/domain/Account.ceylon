import javax.validation.constraints {
    size,
    size__GETTER,
    notNull,
    notNull__GETTER,
    pattern,
    pattern__GETTER,
    pattern__FIELD
}
import java.lang {
    JString=String
}
import ceylon.language {
    CString=String
}
//import com.vasileff.csmpetstore {
//    TypeUtils { ceylonString }
//}


shared class Account satisfies PSDomainObject<String> {

    size__GETTER { min=3; max=75; }
    pattern__FIELD { regexp="(?U)[\\p{Alnum}\\p{gc=Pc}]*"; }
    notNull__GETTER late shared variable 
    JString? username;

    size__GETTER { min=1; max=75; }
    late shared variable
    JString? email;

    size__GETTER { min=1; max=50; }
    notNull__GETTER late shared variable
    JString? fullName;

    size__GETTER { max=50; }
    late shared variable JString? country;

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

    shared new Account() {}

//    shared actual String string
//        =>  TypeUtils.ceylonString(username) else "null";
//
    shared actual String? getPK()
        //=>  ceylonString(username);
        => nothing;

}


//
//	public static ceylon.language.String ceylonString(java.lang.Object string) {
//		if (string != null) {
//			return ceylon.language.String.instance((String) string);
//		}
//		return null;
//	}
