import ceylon.html {
    ...
}

import java.lang {
    JString=String
}

import org.springframework.stereotype {
    component
}

shared component
class WelcomeView() extends HtmlView() {

    shared actual
    Html generateHtml(Map<JString, Object> model)
        =>  page {
                currentPage = home;
                title = "Welcome";
                H1 { "Hello from Ceylon"; },
                P {
                    classNames="lead";
                    text="This is a paragraph with some text.";
                }
            };
}
