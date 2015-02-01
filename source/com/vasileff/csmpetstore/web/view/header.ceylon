import ceylon.html {
    CssLink,
    Head
}

Head header(String title)
    =>  Head {
            title = title;
            CssLink("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css"),
            CssLink("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css"),
            CssLink("resources/css/starter-template.css")
        };