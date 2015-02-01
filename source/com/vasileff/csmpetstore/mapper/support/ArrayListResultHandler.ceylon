import org.apache.ibatis.session {
    ResultHandler,
    ResultContext
}
import ceylon.collection {
    ArrayList
}

shared
class ArrayListResultHandler<Element>() satisfies ResultHandler {

    shared
    ArrayList<Element> results = ArrayList<Element>();

    shared actual
    void handleResult(ResultContext resultContext) {
        assert (is Element result = resultContext.resultObject);
        results.add(result);
    }
}
