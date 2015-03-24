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
class NotFoundView() extends BaseView() {

    shared actual
    Html generateHtml(Model model) {
        return page {
            currentPage = home; // FIXME make currentPage optional
            title = "Error";
            Div {
                classNames = "well";
                style = "margin-top:2em;";
                H2 {
                    text = message("screen.exception.404");
                    classNames = "text-center";
                    style = "padding:0px;margin:0px;";
                }
            }
        };
    }
}
