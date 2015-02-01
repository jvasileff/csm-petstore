import ceylon.html {
    Html,
    html5,
    BlockOrInline,
    Body,
    Snippet,
    Script,
    Div
}

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
                Div {
                    classNames="starter-template";
                    *children
                }
            },
            Script { src = "https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"; },
            Script { src = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"; }
        };
    };
}