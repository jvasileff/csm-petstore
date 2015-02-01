import java.util {
    JMap=Map,
    JHashMap=HashMap
}
import ceylon.interop.java {
    CeylonIterable
}

shared class CeylonMap2<out Key, out Item>(JMap<out Key, out Item> map)
        satisfies Map<Key, Item>
        given Key satisfies Object
        given Item satisfies Object
    {

    get(Object key) => map.get(key);

    defines(Object key) => map.containsKey(key);

    iterator()
            => CeylonIterable(map.entrySet())
                .map((entry) => entry.key->entry.\ivalue)
                .iterator();

    //put(Key key, Item item) => map.put(key, item);

    //remove(Key key) => map.remove(key);

    /*removeEntry(Key key, Item item) => map.remove(key, item);

    replaceEntry(Key key, Item item, Item newItem)
            => map.replace(key, item, newItem);*/

    //clear() => map.clear();

    clone() => CeylonMap2(JHashMap(map));

    equals(Object that)
            => (super of Map<Key,Item>).equals(that);

    hash => (super of Map<Key,Item>).hash;

}