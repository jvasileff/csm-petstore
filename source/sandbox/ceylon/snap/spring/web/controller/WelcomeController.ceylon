import org.springframework.stereotype {
    controller
}
import org.springframework.web.bind.annotation {
    responseBody,
    requestMapping
}

shared controller
class WelcomeController() {

    shared responseBody
    requestMapping({"/robots.txt"})
    String robotsTxt()
        =>  "User-agent: *\nDisallow: /\n";

}