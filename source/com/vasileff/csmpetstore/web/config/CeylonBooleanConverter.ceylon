import org.springframework.core.convert.converter {
    Converter
}
import java.lang {
    IllegalArgumentException,
    JString=String
}

shared
class CeylonBooleanConverter()
        satisfies Converter<JString, Boolean> {

    shared actual
    Boolean? convert(JString s) {
        if (exists result = parseBoolean(s.string)) {
            return result;
        }
        else {
            throw IllegalArgumentException(
                "Cannot convert '``s``' to Boolean.");
        }
    }
}
