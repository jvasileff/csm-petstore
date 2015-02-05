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
            "Cannot initialize `` `DomainObjectType` ``: exactly one non-nullable " +
            "attribute must be annotated with `primaryKey`");
    }

    shared
    void set(Property property, Anything newValue) {
        log.trace(() => "setting property " + property.string);
        checkIsField(property);
        updatedPropertySet.add(property);
        propertyMap.put(property, newValue);
    }

    shared
    Anything get(Property property) {
        log.trace(() => "getting property " + property.string);
        checkIsField(property);
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
    String string {
        value result = StringBuilder();
        result.append(domainObjectInterface.declaration.name);
        if (isPrimaryKeySet()) {
            result.append(" pk=");
            result.append(primaryKey()?.string else "<null>");
        }
        return result.string;
    }

    shared
    void clearUpdated()
        =>  updatedPropertySet.clear();

    shared
    Integer hashCode(DomainObjectType thisProxy)
        // FIXME better hashcode
        =>  this.hash;

    shared
    Boolean equalTo(DomainObjectType thisProxy, Anything other) {
        // FIXME better equals
        if (!is DomainObjectType other) {
            return false;
        }
        else {
            return thisProxy === other;
        }
    }

    void checkIsField(Property property) {
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
