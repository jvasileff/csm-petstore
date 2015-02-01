import ceylon.html {
    ...
}
import ceylon.html.serializer {
    NodeSerializer
}
import ceylon.interop.java {
    CeylonMap,
    CeylonIterable,
    createJavaByteArray
}

import java.lang {
    JString=String
}
import java.util {
    JMap=Map,
    JHashMap=HashMap,
    Collections
}

import javax.servlet.http {
    HttpServletRequest,
    HttpServletResponse
}

import org.springframework.web.servlet {
    View
}
import org.springframework.stereotype {
    component
}
import org.springframework.web.servlet.view {
    AbstractView
}
import javax.annotation {
    postConstruct
}
import org.springframework.context {
    ApplicationContext
}
import ceylon.io.charset {
    utf8
}
import java.io {
    ByteArrayOutputStream
}

//shared abstract
//class HtmlView() extends AbstractView() {
//
//    postConstruct
//    shared void setup() {
//        contentType = "text/html;charset=UTF-8";
//    }
//
//    shared actual // FIXME see compiler bug #
//    void setApplicationContext(ApplicationContext ctx)
//        =>  super.applicationContext = ctx;
//
//    shared actual // FIXME see compiler bug #
//    void setBeanName(String beanName)
//        =>  super.beanName = beanName;
//
//    shared actual
//    void renderMergedOutputModel(JMap<JString, Object> model,
//            HttpServletRequest httpServletRequest,
//            HttpServletResponse httpServletResponse) {
//
//        //Map<String, Object> cModel = HashMap {
//        //    for (key->entry in CeylonMap2(model))
//        //        key.string -> entry
//        //};
//
//        //Map<String, Object> cModel = HashMap {
//        //    entries = CeylonIterable(model.entrySet()).map((entry)
//        //        => entry.key.string->entry.\ivalue);
//        //};
//
//        //value bogus = Collections.unmodifiableMap(model);
//        //Map<JString, Object> cModel = CeylonMap(bogus);
//
//        setResponseContentType(httpServletRequest, httpServletResponse);
//        httpServletResponse.writer.print(generateHtml(CeylonMap(model)));
//    }
//
//    shared formal
//    String generateHtml(Map<JString, Object> model);
//}

shared abstract
class HtmlView() satisfies View {

    shared actual default
    String contentType = "text/html;charset=UTF-8";

    shared actual
    void render(JMap<JString, out Object> model,
            HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse) {

        //Map<String, Object> cModel = HashMap {
        //    for (key->entry in CeylonMap2(model))
        //        key.string -> entry
        //};

        //Map<String, Object> cModel = HashMap {
        //    entries = CeylonIterable(model.entrySet()).map((entry)
        //        => entry.key.string->entry.\ivalue);
        //};

        value bogus = Collections.unmodifiableMap(model);
        Map<JString, Object> cModel = CeylonMap(bogus);

        value bytes = createJavaByteArray(utf8.encode(generateHtml(cModel)));

        httpServletResponse.contentType = contentType;
        httpServletResponse.setContentLength(bytes.size);
        httpServletResponse.outputStream.write(
            createJavaByteArray(utf8.encode(generateHtml(cModel))));
    }

    shared formal
    String generateHtml(Map<JString, Object> model);
}

shared component
class WelcomeView() extends HtmlView() {

    shared actual
    String generateHtml(Map<JString, Object> model) {
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
                        buildNavBar(home)
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

shared class CeylonMap2<out Key, out Item>(JMap<out Key, out Item> map)
        satisfies Map<Key, Item>
        given Key satisfies Object
        given Item satisfies Object
    {

    get(Object key) => map.get(key);

    defines(Object key) => map.containsKey(key);

    iterator()
            => CeylonIterable(map.entrySet())
                .map((entry) => entry.key->entry.\ivalue)
                .iterator();

    //put(Key key, Item item) => map.put(key, item);

    //remove(Key key) => map.remove(key);

    /*removeEntry(Key key, Item item) => map.remove(key, item);

    replaceEntry(Key key, Item item, Item newItem)
            => map.replace(key, item, newItem);*/

    //clear() => map.clear();

    clone() => CeylonMap2(JHashMap(map));

    equals(Object that)
            => (super of Map<Key,Item>).equals(that);

    hash => (super of Map<Key,Item>).hash;

}