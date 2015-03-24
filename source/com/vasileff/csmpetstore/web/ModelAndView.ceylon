import org.springframework.web.servlet {
    View
}
import ceylon.collection {
    HashMap
}

shared
class ModelAndView(
        view, model = HashMap<String, Object>()) {
    shared View view;
    shared MutableModel model;
}
