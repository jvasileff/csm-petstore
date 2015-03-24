import ceylon.logging {
    Logger,
    logger
}

import com.vasileff.csmpetstore.domain {
    Account
}
import com.vasileff.csmpetstore.domain.support {
    createDomainObject
}
import com.vasileff.csmpetstore.web {
    Model
}
import com.vasileff.csmpetstore.web.view {
    WelcomeView,
    AboutView,
    ContactView,
    home,
    TestFormView
}

import java.util {
    JList=List
}

import javax.inject {
    inject=inject__CONSTRUCTOR
}
import javax.validation {
    valid
}

import org.springframework.stereotype {
    controller
}
import org.springframework.validation {
    BindingResult
}
import org.springframework.web.bind.annotation {
    responseBody,
    requestMapping,
    RequestMethod {
        get=\iGET,
        post=\iPOST
    },
    modelAttribute
}
import org.springframework.web.context {
    WebApplicationContext
}
import org.springframework.web.servlet {
    View
}

Logger log = logger(`package`);

shared controller inject
class WelcomeController(
        WelcomeView welcomeView,
        AboutView aboutView,
        ContactView contactView,
        TestFormView testFormView,
        WebApplicationContext webApplicationContext) {

    shared modelAttribute("dummyKey")
    String dummyKey => "dummyVal";

    shared modelAttribute
    Account emptyAccount {
        value account = createDomainObject(`Account`);
        account.username = "";
        account.country = "";
        return account;
    }

    requestMapping({"/robots.txt"})
    shared responseBody
    String robotsTxt()
        =>  "User-agent: *\nDisallow: /\n";

    shared requestMapping {\ivalue={"/"}; method={get}; }
    View rootRequest()
        =>  redirect(home.url);

    shared requestMapping {\ivalue={"/welcome"}; method={get};}
    View welcome(Model model, Account account) {
        account.country = null;
        account.email = null;
        account.fullName = "";
        account.username = "";
        account.testBoolean = false;
        account.testInteger = 0;
        return welcomeView;
    }

    shared requestMapping {\ivalue={"/about"}; method={get, post};}
    View about(valid Account account, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return welcomeView;
        }
        return aboutView;
    }

    shared requestMapping {\ivalue={"/contact"}; method={get};}
    View contact()
        =>  contactView;

    shared requestMapping {\ivalue={"/testForm"}; method={get};}
    View testForm()
        =>  testFormView;

    shared requestMapping {\ivalue={"/testForm"}; method={post};}
    View testFormPost(Model model, StringsHolder stringsHolder) {
        log.debug(model.string);
        log.debug(stringsHolder.strings?.string else "null");
        return testFormView;
    }
}

shared
class StringsHolder() {
    shared variable
    JList<String>? strings = null;
}
