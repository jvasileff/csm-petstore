shared
object urls {
    shared String login = "/login";
    shared String loginError = "/loginError";
    shared String loginConcurrent = "/loginError/concurrent";
    shared String logout = "/logout";
    shared String logoutSuccess = "/";
    shared String securityCheck = "/security-check";

    shared String status403Forbidden = "/403";
    shared String status404NotFound = "/404";
    shared String status500InternalServerError = "/500";
    shared String status999Default = "/999";
}

shared
object loginParameters {
    shared String csrf = "csrf";
    shared String username = "username";
    shared String password = "password";
}

shared
object roles {
    shared String user = "user";
}

shared abstract
class LoginError(shared actual String string)
        of loginBadCredentials | loginConcurrent |
           loginDisabled | loginSuspicious {}

shared
object loginBadCredentials extends LoginError("badCredentials") {}

shared
object loginConcurrent extends LoginError("concurrent") {}

shared
object loginDisabled extends LoginError("disabled") {}

shared
object loginSuspicious extends LoginError("suspicious") {}

shared
LoginError? loginErrorFor(String error)
    =>  `LoginError`.caseValues.find((e)
        =>  e.string == error);
