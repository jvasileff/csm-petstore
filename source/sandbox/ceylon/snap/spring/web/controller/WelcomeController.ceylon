import org.springframework.stereotype {
    controller
}
import org.springframework.web.bind.annotation {
    responseBody,
    requestMapping,
    RequestMethod
}
import sandbox.ceylon.snap.spring.web.view {
    welcomePage
}

shared controller
class WelcomeController() {

    requestMapping({"/robots.txt"})
    shared responseBody
    String robotsTxt()
        =>  "User-agent: *\nDisallow: /\n";

    requestMapping {
            \ivalue={"/"};
            method={RequestMethod.\iGET}; }
    shared
    String rootRequest()
        =>  "redirect:/welcome.html";

    requestMapping {
            \ivalue={"/welcome.html"};
            method={RequestMethod.\iGET};
    }
    shared responseBody
    String welcome()
        =>  welcomePage();

}