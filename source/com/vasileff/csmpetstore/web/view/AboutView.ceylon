import com.vasileff.ceylon.html {
    ...
}

import com.vasileff.csmpetstore.web {
    Model
}

import org.springframework.stereotype {
    component
}
import com.vasileff.csmpetstore.domain {
    Account
}

shared component
class AboutView() extends BaseView() {

    shared actual
    Html generateHtml(Model model) {
        assert (is Account account = model["account"]);
        return page {
                currentPage = about;
                title = "About";
                Div {
                    classNames="starter-template";
                    H1 { "All about the petstore"; },
                    P {
                        classNames="lead";
                        text="This is a paragraph with some text.";
                    }
                },
                Div {
                    H3{ "The Account Information"; },
                    table {
                        header = ["Field", "Value"];
                        rows = [
                            ["Username", account.username],
                            ["Full Name", account.fullName],
                            ["Email", account.email],
                            ["Test Boolean", account.testBoolean?.string],
                            ["Test Integer", account.testInteger?.string]
                        ];
                    }
                }
            };
        }
}
