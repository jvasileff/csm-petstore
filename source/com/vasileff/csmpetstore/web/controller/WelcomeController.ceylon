import ceylon.logging {
    Logger,
    logger
}

import com.vasileff.csmpetstore.web.view {
    WelcomeView,
    AboutView,
    ContactView,
    home
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
class WelcomeController(
        WelcomeView welcomeView,
        AboutView aboutView,
        ContactView contactView) {

    requestMapping({"/robots.txt"})
    shared responseBody
    String robotsTxt()
        =>  "User-agent: *\nDisallow: /\n";

    shared requestMapping {\ivalue={"/"}; method={get}; }
    View rootRequest()
        =>  redirect(home.url);

    shared requestMapping {\ivalue={"/welcome"}; method={get};}
    View welcome()
        =>  welcomeView;

    shared requestMapping {\ivalue={"/about"}; method={get};}
    View about()
        =>  aboutView;

    shared requestMapping {\ivalue={"/contact"}; method={get};}
    View contact()
        =>  contactView;

}
