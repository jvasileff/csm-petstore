import ceylon.interop.java {
    CeylonIterable,
    javaString
}

import java.lang {
    JString=String
}
import java.util {
    JMap=Map,
    JHashMap=HashMap
}

shared
class CeylonStringMap<out Item>(JMap<JString, out Item> map)
        satisfies Map<String, Item> {

    get(Object key)
        =>  if (is String key)
            then map.get(javaString(key))
            else map.get(key);

    defines(Object key)
        =>  if (is String key)
            then map.containsKey(javaString(key))
            else map.containsKey(key);

    iterator()
        =>  CeylonIterable(map.entrySet())
                .map((entry) => entry.key.string->entry.\ivalue)
                .iterator();

    clone() => CeylonStringMap(JHashMap(map));

    equals(Object that) => (super of Map<String,Item>).equals(that);

    hash => (super of Map<String,Item>).hash;

}
