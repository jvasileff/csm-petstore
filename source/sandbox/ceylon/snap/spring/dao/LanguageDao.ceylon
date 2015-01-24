import ceylon.interop.java {
    CeylonList
}

import javax.inject {
    inject
}

import org.springframework.stereotype {
    component
}
import org.springframework.transaction.annotation {
    transactional
}

import sandbox.ceylon.snap.spring.domain {
    Language
}
import sandbox.ceylon.snap.spring.mapper {
    LanguageMapper
}

shared interface LanguageDao satisfies SSDao<Language, Integer> {
    shared formal List<Language> findAll();
}

transactional component inject class LanguageDaoImpl(LanguageMapper mapper)
        extends BaseDao<Language, Integer>(mapper)
        satisfies LanguageDao {

    shared actual List<Language> findAll()
        =>  CeylonList(mapper.findAll());
}
