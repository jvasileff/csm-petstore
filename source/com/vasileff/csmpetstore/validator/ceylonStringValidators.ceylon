import ceylon.interop.java {
    javaString
}

import java.lang {
    JString=String
}

import javax.validation.constraints {
    Size,
    Pattern
}

import org.hibernate.validator.internal.constraintvalidators {
    SizeValidatorForCharSequence,
    PatternValidator
}

shared
class SizeValidatorForCeylonString()
extends ConstraintValidatorAdapter<Size, JString, String>
    (SizeValidatorForCharSequence(), javaString) {}

shared
class PatternValidatorForCeylonString()
extends ConstraintValidatorAdapter<Pattern, JString, String>
    (PatternValidator(), javaString) {}
