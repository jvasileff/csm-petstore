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
        };
        Body {
            H2 {
                "Hello from Ceylon";
            }
        };
    };

    value result = StringBuilder();
    NodeSerializer(result.append).serialize(html);
    return result.string;
}