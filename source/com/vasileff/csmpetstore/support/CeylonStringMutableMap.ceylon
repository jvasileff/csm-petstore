import ceylon.collection {
    MutableMap
}
import ceylon.interop.java {
    javaString
}

import java.lang {
    JString=String
}

shared
class CeylonStringMutableMap<Item>(MutableMap<JString, Item> delegate)
        extends CeylonStringMap<Item>(delegate)
        satisfies MutableMap<String, Item> {

    shared actual
    void clear()
        =>  delegate.clear();

    shared actual
    CeylonStringMutableMap<Item> clone()
        =>  CeylonStringMutableMap(delegate.clone());

    shared actual
    Item? put(String key, Item item)
        =>  delegate.put(javaString(key), item);

    shared actual
    Item? remove(String key)
        =>  delegate.remove(javaString(key));
}
