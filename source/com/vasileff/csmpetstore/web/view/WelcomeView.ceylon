import ceylon.html {
    ...
}

import com.vasileff.csmpetstore.domain {
    Account
}
import com.vasileff.csmpetstore.web {
    Model
}

import org.springframework.stereotype {
    component
}

shared component
class WelcomeView() extends HtmlView() {

    shared actual
    Html generateHtml(Model model) {
        assert (is Account account = model["account"]);
        return page {
            currentPage = home;
            title = "Welcome";
            Div {
                classNames="starter-template";
                H1 { "Hello from Ceylon"; },
                P {
                    classNames="lead";
                    text="This is a paragraph with some text.";
                }
            },
            Div {
                Form {
                    action = "about";
                    method = "POST";
                    id = "account";
                    formGroup {
                        id = "username";
                        labelText = "Username";
                        placeholder = "Enter Username";
                        type = text;
                        valueOf = account.username;
                    },
                    formGroup {
                        id = "email";
                        labelText = "Email Address";
                        placeholder = "Enter Email";
                        type = text;
                        valueOf = account.email else "";
                    },
                    formGroup {
                        id = "fullName";
                        labelText = "Full Name";
                        placeholder = "Your Name";
                        type = text;
                        valueOf = account.fullName;
                    },
                    formGroup {
                        id = "testBoolean";
                        labelText = "Test Boolean";
                        placeholder = "true or false";
                        type = text;
                        valueOf = account.testBoolean.string;
                    },
                    formGroup {
                        id = "testInteger";
                        labelText = "Test Integer";
                        placeholder = "Enter Some Number";
                        type = text;
                        valueOf = account.testInteger.string;
                    },
                    Div {
                        Button {
                            classNames = "btn btn-default";
                            type = submit;
                            text = "Submit";
                        }
                    }
                }
            }
        };
    }

}
