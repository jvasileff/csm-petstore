import ceylon.io.charset {
    utf8
}
import java.lang {
    JString=String
}
import java.util {
    JMap=Map,
    Collections
}
import org.springframework.web.servlet {
    View
}
import javax.servlet.http {
    HttpServletRequest,
    HttpServletResponse
}
import ceylon.interop.java {
    createJavaByteArray,
    CeylonMap
}
import ceylon.html.serializer {
    NodeSerializer
}
import ceylon.html {
    Html
}
import java.io {
    ByteArrayOutputStream
}

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

        Map<JString, Object> cModel =
            CeylonMap(Collections.unmodifiableMap(model));

        value baos = ByteArrayOutputStream(1024);
        void writeBytes(String string)
            =>  baos.write(createJavaByteArray(utf8.encode(string)));
        NodeSerializer(writeBytes).serialize(generateHtml(cModel));

        httpServletResponse.contentType = contentType;
        httpServletResponse.setContentLength(baos.size());
        baos.writeTo(httpServletResponse.outputStream);
        httpServletResponse.outputStream.flush();
    }

    shared formal
    Html generateHtml(Map<JString, Object> model);
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

