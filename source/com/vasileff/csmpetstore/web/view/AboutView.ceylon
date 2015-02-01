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
class AboutView() extends HtmlView() {

    shared actual
    Html generateHtml(Map<JString, Object> model)
        =>  page {
                currentPage = about;
                title = "About";
                H1 { "All about the petstore"; },
                P {
                    classNames="lead";
                    text="This is a paragraph with some text.";
                }
            };
}
