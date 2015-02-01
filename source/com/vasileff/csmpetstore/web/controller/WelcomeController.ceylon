import ceylon.logging {
    Logger,
    logger
}

import com.vasileff.csmpetstore.web.view {
    WelcomeView
}

import javax.inject {
    inject=inject__CONSTRUCTOR
}

import org.springframework.stereotype {
    controller
}
import org.springframework.web.bind.annotation {
    responseBody,
    requestMapping,
    RequestMethod {
        get=\iGET
    }
}
import org.springframework.web.servlet {
    View
}

Logger log = logger(`package`);

shared controller inject
class WelcomeController(WelcomeView welcomeView) {

    requestMapping({"/robots.txt"})
    shared responseBody
    String robotsTxt()
        =>  "User-agent: *\nDisallow: /\n";

    requestMapping {\ivalue={"/"}; method={get}; }
    shared
    String rootRequest()
        =>  "redirect:/welcome.html";

    requestMapping {\ivalue={"/welcome.html"}; method={get};}
    shared
    View welcome()
        =>  welcomeView;

}
