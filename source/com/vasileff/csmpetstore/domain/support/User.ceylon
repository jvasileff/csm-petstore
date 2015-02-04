import com.vasileff.csmpetstore.domain {
    PSDomainObject
}
shared interface User satisfies PSDomainObject<String> {

    shared variable formal String username;
    shared variable formal String fullName;

    shared default String xn => "x";
    shared default String doSomething(String x) => x.uppercased;

    shared default T echo<T>(T t) => t;

    shared formal String? exNullableString1;
    shared formal String? exNullableString2;
    shared formal String exString;
    shared formal Integer? exNullableInteger1;
    shared formal Integer? exNullableInteger2;
    shared formal Integer exInteger;
    
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
    shared actual String? getPK() => null;
    shared actual variable String username = "";
    shared actual variable String username2 = "";

    shared actual String? exNullableString1 = "";
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
