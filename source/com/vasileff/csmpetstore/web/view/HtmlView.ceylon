import ceylon.html {
    Html
}
import ceylon.html.serializer {
    NodeSerializer
}
import ceylon.interop.java {
    createJavaByteArray,
    createJavaObjectArray
}
import ceylon.io.charset {
    utf8
}

import com.vasileff.csmpetstore.support {
    CeylonStringMap
}
import com.vasileff.csmpetstore.web {
    Model
}

import java.io {
    ByteArrayOutputStream
}
import java.lang {
    JString=String
}
import java.util {
    JMap=Map
}

import javax.servlet.http {
    HttpServletRequest,
    HttpServletResponse
}

import org.springframework.web.servlet {
    View
}
import org.springframework.validation {
    BindingResult
}
import javax.inject {
    inject=inject__SETTER
}
import org.springframework.web.context {
    WebApplicationContext
}
import org.springframework.context {
    NoSuchMessageException
}

shared abstract
class HtmlView()
        satisfies View & WebApplicationContextAware {

    shared actual late inject
    WebApplicationContext webApplicationContext;

    shared actual default
    String contentType = "text/html;charset=UTF-8";

    shared actual
    void render(JMap<JString, out Object> model,
            HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse) {

        value baos = ByteArrayOutputStream(1024);
        void writeBytes(String string)
            =>  baos.write(createJavaByteArray(utf8.encode(string)));
        NodeSerializer(writeBytes).serialize(generateHtml(CeylonStringMap(model)));

        httpServletResponse.contentType = contentType;
        httpServletResponse.setContentLength(baos.size());
        baos.writeTo(httpServletResponse.outputStream);
        httpServletResponse.outputStream.flush();
    }

    shared formal
    Html generateHtml(Model model);

    shared
    BindingResult? bindingResult(Model model, String obj) {
        assert (is BindingResult? bindingResult = model[
            "org.springframework.validation.BindingResult." + obj]);
        return bindingResult;
    }

    shared
    String message(String key, {Object*} args = {}) {
        try {
            return webApplicationContext.getMessage(
                key, createJavaObjectArray(args), null);
        }
        catch (NoSuchMessageException e) {
            return "???``key``???";
        }
    }
}

shared
interface WebApplicationContextAware {
    shared formal
    WebApplicationContext webApplicationContext;
}

//shared abstract
//class HtmlView() extends AbstractView() {
//
//    postConstruct
//    shared void setup() {
//        contentType = "text/html;charset=UTF-8";
//    }
//
//    shared actual // FIXME see https://github.com/ceylon/ceylon-compiler/issues/2020
//    void setApplicationContext(ApplicationContext ctx)
//        =>  super.applicationContext = ctx;
//
//    shared actual // FIXME see https://github.com/ceylon/ceylon-compiler/issues/2020
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
