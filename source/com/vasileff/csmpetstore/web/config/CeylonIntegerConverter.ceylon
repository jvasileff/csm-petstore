import org.springframework.core.convert.converter {
    Converter
}
import java.lang {
    IllegalArgumentException,
    JString=String
}

shared
class CeylonIntegerConverter()
        satisfies Converter<JString, Integer> {

    shared actual
    Integer? convert(JString s) {
        if (exists result = parseInteger(s.string)) {
            return result;
        }
        else {
            throw IllegalArgumentException(
                "Cannot convert '``s``' to Integer.");
        }
    }
}
