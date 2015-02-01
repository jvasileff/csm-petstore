import ceylon.html {
    ...
}
import ceylon.html.serializer {
    NodeSerializer
}

shared
String welcomePage() {

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
                    buildNavBar(about)
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

abstract
class TopPage(shared String name) of home | about | contact {}

object home extends TopPage("Home") {}
object about extends TopPage("About") {}
object contact extends TopPage("Contact") {}

Div buildNavBar(TopPage current)
    => Div {
        id="navbar";
        classNames="collapse navbar-collapse";
        Ul {
            classNames="nav navbar-nav";
            children = { home, about, contact }.map<Li>((TopPage page)
                => Li {
                    classNames = if (page == current) then "active" else [];
                    A { href="#"; text=page.name; }
                }
            );
        }
    };
