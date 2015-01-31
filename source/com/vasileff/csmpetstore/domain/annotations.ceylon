import ceylon.language.meta.declaration {
    FunctionOrValueDeclaration
}
import javax.validation {
    constraint,
    ConstraintValidator
}
import java.lang {
    ObjectArray
}
//import java.lang {
    //JObject = Object // Root type may not be imported
//}

//constraint { validatedBy = {`MaxLengthValidator`}; }
//shared final annotation class MaxLengthAnnotation(
//    shared Integer max,
//    shared [Anything*] groups,
//    shared [Anything*] a
//)
//        satisfies OptionalAnnotation<MaxLengthAnnotation, FunctionOrValueDeclaration> {}


//shared annotation MaxLengthAnnotation maxLength(
//    Integer max) => MaxLengthAnnotation (max);

//shared class MaxLengthValidator() satisfies ConstraintValidator<MaxLengthAnnotation, String>() {
//
//}