import ceylon.html {
    ...
}
import ceylon.logging {
    logger,
    Logger
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

Logger log = logger(`package`);

shared component
class WelcomeView()
        extends HtmlView()
        satisfies HtmlForms {

    shared actual
    Html generateHtml(Model model) {
        assert (is Account account = model["account"]);
        value bindingResult = super.bindingResult(model, "account");

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
                    classNames = "form-horizontal";
                    // FIXME https://github.com/ceylon/ceylon-compiler/issues/2099
                    this.formGroup {
                        id = "username";
                        labelText = message("account.username");
                        type = text;
                        valueOf = account.username;
                        errors = bindingResult?.getFieldErrors("username");
                    },
                    this.formGroup {
                        id = "email";
                        labelText = message("account.email");
                        type = text;
                        valueOf = account.email else "";
                        errors = bindingResult?.getFieldErrors("email");
                    },
                    this.formGroup {
                        id = "fullName";
                        labelText = message("account.fullName");
                        type = text;
                        valueOf = account.fullName;
                        errors = bindingResult?.getFieldErrors("fullName");
                    },
                    this.formGroup {
                        id = "testBoolean";
                        labelText = "Test Boolean";
                        placeholder = "true or false";
                        type = text;
                        valueOf = account.testBoolean.string;
                        errors = bindingResult?.getFieldErrors("testBoolean");
                    },
                    this.formGroup {
                        id = "testInteger";
                        labelText = "Test Integer";
                        placeholder = "Enter Some Number";
                        type = text;
                        valueOf = account.testInteger.string;
                        errors = bindingResult?.getFieldErrors("testInteger");
                    },
                    Div {
                        classNames = "form-group";
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
