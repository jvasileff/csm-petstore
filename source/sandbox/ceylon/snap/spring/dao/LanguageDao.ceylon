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

transactional component class LanguageDaoImpl()
        extends BaseDao<Language, Integer>() satisfies LanguageDao {

    shared late actual LanguageMapper mapper;

    shared inject void setMapper(LanguageMapper mapper)
        =>  this.mapper = mapper;

    shared actual List<Language> findAll()
        =>  CeylonList(mapper.findAll());
}
