import ceylon.language.meta.declaration {
    ValueDeclaration
}

shared final annotation
class FieldAnnotation()
        satisfies OptionalAnnotation<FieldAnnotation, ValueDeclaration>{}

shared annotation
FieldAnnotation field() => FieldAnnotation();

shared final annotation
class PrimaryKeyAnnotation()
        satisfies OptionalAnnotation<PrimaryKeyAnnotation, ValueDeclaration>{}

shared annotation
PrimaryKeyAnnotation primaryKey() => PrimaryKeyAnnotation();
