import org.springframework.stereotype {
    controller
}
import org.springframework.web.bind.annotation {
    responseBody,
    requestMapping,
    RequestMethod { get = GET }
}
import sandbox.ceylon.snap.spring.web.view {
    welcomePage
}
import ceylon.logging {
    Logger, logger
}

shared controller
class WelcomeController() {

    requestMapping({"/robots.txt"})
    shared responseBody
    String robotsTxt()
        =>  "User-agent: *\nDisallow: /\n";

    requestMapping {\ivalue={"/"}; method={get}; }
    shared
    String rootRequest()
        =>  "redirect:/welcome.html";

    requestMapping {\ivalue={"/welcome.html"}; method={get};}
    shared responseBody
    String welcome()
        =>  welcomePage();

}

Logger log = logger(`package`);