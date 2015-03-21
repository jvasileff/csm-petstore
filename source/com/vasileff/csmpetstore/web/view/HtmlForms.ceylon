import ceylon.html {
    Input,
    Label,
    InputType,
    Div,
    Span
}
import ceylon.interop.java {
    CeylonIterable
}

import java.util {
    JList=List
}

import org.springframework.validation {
    FieldError
}

shared
interface HtmlForms
        satisfies WebApplicationContextAware {

    shared default
    Div formGroup(
            String id, String labelText,
            InputType type, String valueOf,
            String placeholder = labelText,
            JList<FieldError>? errors = null,
            {String*} inputClassNames = {})
        =>  Div {
                classNames = if (errors?.empty else true)
                             then "form-group"
                             else ["form-group", "has-error"];
                Label {
                    forControl = id;
                    text = labelText;
                    classNames = ["col-sm-2", "control-label"];
                },
                Div {
                    classNames = "col-sm-10";
                    Input {
                        classNames = ["form-control", *inputClassNames];
                        type = type;
                        id = id;
                        name = id;
                        placeholder = placeholder;
                        valueOf = valueOf;
                    },
                    *formErrors(errors)
                }
            };

    shared default
    {Span*} formErrors(JList<FieldError>? errors)
        =>  if (exists errors) then
                { for (error in CeylonIterable(errors))
                    Span {
                        text = webApplicationContext.getMessage(error, null);
                        classNames = "help-block";
                    }
                }
            else {};
}
