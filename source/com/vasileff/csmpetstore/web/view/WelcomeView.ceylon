import ceylon.html {
    ...
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
    Html generateHtml(Model model)
        =>  page {
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
                        Div {
                            classNames = "form-group";
                            Label {
                                forControl = "email";
                                text = "Email Address";
                            },
                            Input {
                                classNames = "form-control";
                                type = email;
                                id = "email";
                                name = "email";
                                placeholder = "Enter Email";
                            }
                        },
                        Div {
                            classNames = "form-group";
                            Label {
                                forControl = "fullName";
                                text = "Full Name";
                            },
                            Input {
                                classNames = "form-control";
                                type = text;
                                id = "fullName";
                                name = "fullName";
                                placeholder = "Your Name";
                            }
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
