import ceylon.html {
    Input,
    Label,
    InputType,
    Div
}

Div formGroup(String id, String labelText, String placeholder,
              InputType type, String valueOf,
              {String*} inputClassNames = {})
    =>  Div {
        classNames = "form-group";
        Label {
            forControl = id;
            text = labelText;
        },
        Input {
            classNames = ["form-control", *inputClassNames];
            type = type;
            id = id;
            name = id;
            placeholder = placeholder;
            valueOf = valueOf;
        }
    };