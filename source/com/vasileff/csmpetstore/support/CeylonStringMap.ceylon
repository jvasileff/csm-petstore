import ceylon.interop.java {
    javaString
}

import java.lang {
    JString=String
}

shared
class CeylonStringMap<out Item>(Map<JString, Item> delegate)
        satisfies Map<String, Item> {

    shared actual default
    CeylonStringMap<Item> clone()
        =>  CeylonStringMap(delegate.clone());

    shared actual
    Boolean defines(Object key)
        =>  if (is String key)
            then delegate.defines(javaString(key))
            else delegate.defines(key);

    shared actual
    Item? get(Object key)
        =>  if (is String key)
            then delegate.get(javaString(key))
            else delegate.get(key);

    shared actual
    Iterator<String->Item> iterator()
        =>  { for (key->item in delegate)
                key.string->item
            }.iterator();

    shared actual
    Boolean equals(Object that)
        =>  (super of Map<String, Item>).equals(that);

    shared actual
    Integer hash
        =>  (super of Map<String, Item>).hash;
}
