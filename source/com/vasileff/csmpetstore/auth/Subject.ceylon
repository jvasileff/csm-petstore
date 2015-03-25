shared
interface Subject {

    shared formal
    String? username;

    shared formal
    Boolean hasAuthorization(String authorization);

    shared formal
    {String*} authorities;

    shared formal
    Boolean authenticated;

}
