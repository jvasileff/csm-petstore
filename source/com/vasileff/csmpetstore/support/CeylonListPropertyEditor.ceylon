import java.beans {
    PropertyEditorSupport
}

shared
class CeylonArrayListPropertyEditor() extends PropertyEditorSupport() {

    shared actual
    Object \ivalue => super.\ivalue;

    assign \ivalue {
        // convert whatever value we get (such as a java List<E>)
        // to a Ceylon ArrayList<E>
        // Problem is that we don't know what E is.
    }

}