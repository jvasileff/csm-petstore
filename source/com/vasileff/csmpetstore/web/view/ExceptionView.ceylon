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
class ExceptionView() extends BaseView() {

    shared actual
    Html generateHtml(Model model) {
        assert (is String errorMessageKey = model["errorMessageKey"]);
        value stackTrace = model["stackTrace"]?.string;
        return page {
            currentPage = home; // FIXME make currentPage optional
            title = "Error";
            Div {
                classNames = "well";
                style = "margin-top:2em;";
                H2 {
                    text = message(errorMessageKey);
                    classNames = "text-center";
                    style = "padding:0px;margin:0px;";
                },
                if (exists stackTrace) then {
                    Hr { style="border-color: black;"; },
                    Pre {
                        text = stackTrace;
                        classNames = "stackTrace";
                    }
                } else null
            }
        };
    }
}
