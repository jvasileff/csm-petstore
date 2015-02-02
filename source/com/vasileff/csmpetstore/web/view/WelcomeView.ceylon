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
                }
            };

}
