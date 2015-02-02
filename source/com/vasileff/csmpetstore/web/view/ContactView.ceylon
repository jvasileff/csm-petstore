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
class ContactView() extends HtmlView() {

    shared actual
    Html generateHtml(Model model)
        =>  page {
                currentPage = contact;
                title = "Contact";
                H1 { "Contact information for the Petstore"; },
                P {
                    classNames="lead";
                    text="This is a paragraph with some text.";
                }
            };

}
