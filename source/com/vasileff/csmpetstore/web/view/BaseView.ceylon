import ceylon.html {
    Html,
    Button,
    html5,
    Nav,
    Span,
    Body,
    Li,
    Tr,
    Script,
    button,
    Div,
    Th,
    A,
    Td,
    BlockOrInline,
    CssLink,
    Ul,
    Snippet,
    Table,
    Head,
    Input,
    Label,
    InputType
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

shared abstract
class BaseView() extends HtmlView() {

    shared
    Html page(currentPage, title, children) {
        TopPage currentPage;
        String title;
        {<BlockOrInline|{BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;
        return Html {
            doctype = html5;
            header(title);
            Body {
                nav(currentPage),
                Div {
                    classNames="container";
                    *children
                },
                Script { src = "https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"; },
                Script { src = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"; }
            };
        };
    }

    shared
    Head header(String title)
        =>  Head {
                title = title;
                CssLink("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css"),
                CssLink("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css"),
                CssLink("resources/css/starter-template.css")
            };

    shared
    Nav nav(TopPage current)
        =>  Nav {
                classNames="navbar navbar-inverse navbar-fixed-top";
                Div {
                    classNames="container";
                    Div {
                        classNames="navbar-header";
                        Button {
                            type=button;
                            classNames="navbar-toggle collapsed";
                            nonstandardAttributes=[
                                "data-toggle"->"collapse",
                                "data-target"->"#navbar",
                                "aria-expanded"->"false",
                                "aria-controls"->"navbar"
                            ];
                            Span {
                                classNames="sr-only";
                                text="Toggle navigation";
                            },
                            Span { classNames="icon-bar"; },
                            Span { classNames="icon-bar"; },
                            Span { classNames="icon-bar"; }
                        },
                        A {
                            classNames="navbar-brand";
                            href="#";
                            text="CSM Petstore";
                        }
                    },
                    Div {
                        id="navbar";
                        classNames="collapse navbar-collapse";
                        Ul {
                            classNames="nav navbar-nav";
                            children = { home, about, contact }.map<Li>((TopPage page)
                                => Li {
                                    classNames = if (page == current) then "active" else [];
                                    A { href=page.url; text=page.name; }
                                }
                            );
                        }
                    }
                }
            };

    shared
    Table table(
        {String*} classNames = {},
        {String*}? header = null,
        {{String?*}*}? rows = null) {

        return Table {
            classNames = ["table", *classNames];
            header = header?.map((entry) => Th(entry)) else {};
            rows = rows?.map((row) => Tr {
                row.map((cell) => Td(cell else ""))
            }) else {};
        };
    }

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
