import com.vasileff.csmpetstore.domain {
    Account
}
import com.vasileff.csmpetstore.domain.support {
    createDomainObject
}
import com.vasileff.csmpetstore.support {
    log
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

shared controller inject
class WelcomeController(
        WelcomeView welcomeView,
        AboutView aboutView,
        ContactView contactView,
        TestFormView testFormView,
        WebApplicationContext webApplicationContext) {

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

    shared requestMapping { {"/"}; method={get}; }
    View rootRequest()
        =>  redirect(home.url);

    shared requestMapping { {"/welcome"}; method={get};}
    View welcome(Model model, Account account) {
        // initialize with default values.
        // another option would be to have domain
        // objects implement Correspondence
        // and return null on uninitialized fields, and
        // provide default values in the template

        // additional note: all are now nullable and can be read, even
        // when not set. So this can definitely be moved to the view.
        account.country = null;
        account.email = null;
        account.fullName = "";
        account.username = "";
        account.testBoolean = false;
        account.testInteger = 0;
        return welcomeView;
    }

    shared requestMapping { {"/about"}; method={get, post};}
    View about(valid Account account, BindingResult bindingResult)
        =>  if (bindingResult.hasErrors())
            then welcomeView
            else aboutView;

    shared requestMapping { {"/contact"}; method={get};}
    View contact()
        =>  contactView;

    shared requestMapping { {"/testForm"}; method={get};}
    View testForm()
        =>  testFormView;

    shared requestMapping { {"/testForm"}; method={post};}
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
