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
                Div {
                    classNames="starter-template";
                    H1 { "Contact information for the Petstore"; },
                    P {
                        classNames = "lead";
                        text="This is a paragraph with some text.";
                    }
                },
                Div {
                    H3 { "Model Map Dump"; },
                    table {
                        classNames = {"table-bordered"};
                        header = ["Key", "Item"];
                        rows = model.map((entry)
                            => [entry.key, entry.item.string]);
                    }
                }
            };

}

