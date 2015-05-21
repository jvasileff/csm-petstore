import com.vasileff.ceylon.html {
    ...
}

import com.vasileff.csmpetstore.web {
    Model
}

import javax.inject {
    inject=inject__SETTER
}
import javax.servlet.http {
    HttpServletRequest
}

import org.springframework.stereotype {
    component
}

shared component
class LoginView() extends BaseView() {

    shared late inject
    HttpServletRequest request;

    shared actual
    Html generateHtml(Model model) {
        return page {
            currentPage = login;
            title = "CSM Petstore";
            Div {
                classNames="starter-template";
                H1 { "Please Sign In"; }
            },
            Div {
                Form {
                    action = "security-check";
                    method = "POST";
                    id = "login";
                    classNames = "form-horizontal";
                    formGroup {
                        id = "username";
                        labelText = message("screen.login.username");
                        type = text;
                        valueOf = "";
                    },
                    formGroup {
                        id = "password";
                        labelText = message("screen.login.password");
                        type = password;
                        valueOf = "";
                    },
                    Div {
                        classNames = "form-group";
                        extraHiddenFields(),
                        Div {
                            classNames = ["col-sm-offset-2", "col-sm-10"];
                            Button {
                                classNames = "btn btn-default";
                                type = submit;
                                text = "Submit";
                            }
                        }
                    }
                }
            }
        };
    }
}
