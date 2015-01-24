import java.util {
    JList=List
}

import org.springframework.stereotype {
    component
}

import sandbox.ceylon.snap.spring.domain {
    Language
}

component shared interface LanguageMapper
        satisfies PSMapper<Language, Integer> {

    shared formal void initialize();

    shared formal JList<Language> findAll();

}
