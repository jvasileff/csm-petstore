import com.vasileff.csmpetstore.domain {
    PSDomainObject
}
import ceylon.language.meta.model {
    Interface,
    Attribute
}
import ceylon.collection {
    HashMap,
    HashSet
}

class DomainObjectDelegate<DomainObjectType, PK>(domainObjectInterface)
        given DomainObjectType satisfies PSDomainObject<PK>
        given PK satisfies Comparable<PK> {

    shared alias Property => Attribute<DomainObjectType>;

    Interface<DomainObjectType> domainObjectInterface;

    value propertyMap = HashMap<Property, Anything>();

    value updatedPropertySet = HashSet<Property>();

    Attribute<DomainObjectType, PK, Nothing> primaryKeyProperty;

    if (nonempty candidates = domainObjectInterface
            .getAttributes<DomainObjectType, PK, Nothing>
                (`PrimaryKeyAnnotation`), candidates.size == 1) {
        primaryKeyProperty = candidates.first;
    } else {
        throw Exception(
            "Exactly one attribute must be annotated with `primaryKey`");
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
    PK? primaryKey {
        assert (is PK? pk = get(primaryKeyProperty));
        return pk;
    }

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
    void clearUpdated()
        =>  updatedPropertySet.clear();

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
