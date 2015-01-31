import java.lang.annotation {
    JAnnotation=Annotation
}

import javax.validation {
    ConstraintValidator,
    ConstraintValidatorContext
}

shared abstract
class ConstraintValidatorAdapter
        <Constraint, in DelegateType, Type>
        (delegate, coerce)
        satisfies ConstraintValidator<Constraint, Type>
        given Constraint satisfies JAnnotation {

    ConstraintValidator<Constraint, in DelegateType> delegate;
    DelegateType(Type) coerce;

	shared actual
	void initialize(Constraint parameters)
        =>  delegate.initialize(parameters);

    shared actual
    Boolean isValid(Type? item,
                    ConstraintValidatorContext context)
        =>  delegate.isValid(
                if (exists item)
                    then coerce(item)
                    else null,
                context);
}