import ceylon.html {
    Button,
    Nav,
    Span,
    A,
    button,
    Div,
    Ul,
    Li
}

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
