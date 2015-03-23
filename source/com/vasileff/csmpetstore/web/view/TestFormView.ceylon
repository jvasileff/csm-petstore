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
class TestFormView() extends BaseView() {

    shared actual
    Html generateHtml(Model model) {
        //assert (is Account account = model["account"]);
        //value bindingResult = super.bindingResult(model, "account");

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
                    action = "testForm";
                    method = "POST";
                    id = "stringsHolder";
                    classNames = "form-horizontal";
                    formGroup {
                        id = "cb_one";
                        name = "strings";
                        labelText = "One";
                        type = checkbox;
                        valueOf = "one";
                    },
                    formGroup {
                        id = "cb_two";
                        name = "strings";
                        labelText = "Two";
                        type = checkbox;
                        valueOf = "two";
                    },
                    Div {
                        classNames = "form-group";
                        HiddenInput {
                            name="_strings";
                            valueOf="on";
                        },
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
