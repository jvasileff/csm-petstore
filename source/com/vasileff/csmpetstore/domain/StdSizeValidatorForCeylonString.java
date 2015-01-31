package com.vasileff.csmpetstore.domain;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import javax.validation.constraints.Size;

import org.springframework.stereotype.Component;

import ceylon.language.String;

@Component
public class StdSizeValidatorForCeylonString
		implements ConstraintValidator<Size, String> {

	private int min;
	private int max;

	@Override
	public void initialize(Size parameters) {
		this.min = parameters.min();
		this.max = parameters.max();
		validateParameters();
	}

	@Override
	public boolean isValid(String string, ConstraintValidatorContext ctx) {
		if ( string == null ) {
			return true;
		}
		long length = string.getSize();
		return length >= min && length <= max;
	}

	private void validateParameters() {
		if ( min < 0 ) {
			throw new RuntimeException("min cannot be negative");
		}
		if ( max < 0 ) {
			throw new RuntimeException("max cannot be negative");
		}
		if ( max < min ) {
			throw new RuntimeException("length cannot be negative");
		}
	}

}
