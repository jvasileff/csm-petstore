import ceylon.html {
    ...
}
import ceylon.html.serializer {
    NodeSerializer
}

shared String welcomePage() {

    value html = Html {
        doctype = html5;
        Head {
            title = "Welcome";
            CssLink("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css"),
            CssLink("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css"),
            CssLink("resources/css/starter-template.css")
        };
        Body {
            Nav {
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
                            Li {
                                classNames="active";
                                A { href="#"; text="Home"; }
                            },
                            Li {
                                A { href="#"; text="About"; }
                            },
                            Li {
                                A { href="#"; text="Contact"; }
                            }
                        }
                    }
                }
            },
            Div {
                classNames="container";
                Div {
                    classNames="starter-template";
                    H1 { "Hello from Ceylon"; },
                    P {
                        classNames="lead";
                        text="This is a paragraph with some text.";
                    }
                }
            },
            Script { src = "https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"; },
            Script { src = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"; }
        };
    };

    value result = StringBuilder();
    NodeSerializer(result.append).serialize(html);
    return result.string;

}


shared class Div(text = "", String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            children = {})
        extends BaseElement(id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies TextNode & BlockElement & ParentNode<BlockOrInline> {

    shared actual String text;

    shared actual {<BlockOrInline|{BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;

    tag = Tag("div");

}
