import ceylon.collection {
    HashMap,
    HashSet
}
import ceylon.language.meta.model {
    Interface,
    Attribute
}

class DomainObjectDelegate<DomainObjectType, PrimaryKey>(domainObjectInterface)
        given DomainObjectType satisfies DomainObject<PrimaryKey, DomainObjectType> {

    shared alias Property => Attribute<DomainObjectType>;

    Interface<DomainObjectType> domainObjectInterface;

    value propertyMap = HashMap<Property, Anything>();

    value updatedPropertySet = HashSet<Property>();

    Attribute<DomainObjectType, PrimaryKey, Nothing> primaryKeyProperty;

    if (nonempty candidates = domainObjectInterface
            .getAttributes<DomainObjectType, PrimaryKey, Nothing>
                (`PrimaryKeyAnnotation`), candidates.size == 1) {
        primaryKeyProperty = candidates.first;
    } else {
        throw Exception(
            "Cannot initialize `` `DomainObjectType` ``; exactly one non-nullable " +
            "attribute must be annotated with `primaryKey`");
    }

    [Property*] toStringAttributes =
        domainObjectInterface.getAttributes<DomainObjectType>(`ToStringAnnotation`);

    shared
    void set(Property property, Anything newValue) {
        log.trace(() => "setting property " + property.string);
        checkField(property);
        updatedPropertySet.add(property);
        propertyMap.put(property, newValue);
    }

    shared
    Anything get(Property property) {
        log.trace(() => "getting property " + property.string);
        checkField(property);
        checkDefined(property);
        return propertyMap[property];
    }

    shared
    Boolean primaryKeySet
        =>  propertyMap.defines(primaryKeyProperty);

    shared
    Boolean isSet(Property* properties)
        =>  if (properties.empty)
            then !propertyMap.empty
            else propertyMap.definesAny(properties);

    shared
    Boolean isUpdated(Property* properties)
        =>  if (properties.empty)
            then !updatedPropertySet.empty
            else updatedPropertySet.containsAny(properties);
    
    shared
    Anything primaryKey()
        =>  get(primaryKeyProperty);

    shared 
    Boolean isPrimaryKeySet()
        =>  isSet(primaryKeyProperty);

    shared actual
    String string
        =>  let (vals = ", ".join(toStringAttributes.map((property)
                    =>  property.declaration.name + "=" + (
                            if (isSet(property))
                            then (get(property)?.string else "<null>")
                            else "<uninitialized>"))))
            domainObjectInterface.declaration.name + "{" + vals + "}";

    shared
    void clearUpdated()
        =>  updatedPropertySet.clear();

    shared
    Integer hashCode(DomainObjectType thisProxy)
        =>  primaryKeyOrNull(thisProxy)?.hash else this.hash;

    Anything primaryKeyOrNull(DomainObjectType target)
        // going through the proxy is pretty inefficient
        =>  if (target.isPrimaryKeySet())
            then target.primaryKey()
            else null;

    shared
    Boolean equalTo(DomainObjectType thisProxy, Anything other)
        =>  if (!is DomainObjectType other) then
                false
            else if (exists pk1 = primaryKeyOrNull(thisProxy),
                     exists pk2 = primaryKeyOrNull(other)) then
                pk1 == pk2
            else
                thisProxy === other;

    void checkField(Property property) {
        if (property.declaration.annotations<FieldAnnotation>().empty) {
            throw Exception(property.declaration.name + " is not a field.");
        }
    }

    void checkDefined(Property property) {
        if (!propertyMap.defines(property)) {
            throw Exception(property.declaration.name + " has not been set.");
        }
    }
}
