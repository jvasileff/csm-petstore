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

import com.vasileff.csmpetstore.domain {
    Language
}
import com.vasileff.csmpetstore.mapper {
    LanguageMapper
}

shared interface LanguageDao satisfies PSDao<Language, Integer> {
    shared formal List<Language> findAll();
}

transactional component inject class LanguageDaoImpl(LanguageMapper mapper)
        extends BaseDao<Language, Integer>(mapper)
        satisfies LanguageDao {

    shared actual List<Language> findAll()
        =>  CeylonList(mapper.findAll());
}
