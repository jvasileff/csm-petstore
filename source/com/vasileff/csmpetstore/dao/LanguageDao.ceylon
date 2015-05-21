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

shared
interface LanguageDao satisfies PSDao<Language, Integer> {
    shared formal
    List<Language> findAll();
}

transactional component
class LanguageDaoImpl
        extends BaseDao<Language, Integer>
        satisfies LanguageDao {

    LanguageMapper mapper;

    shared inject
    new(LanguageMapper mapper)
            extends BaseDao<Language, Integer>(mapper) {
        this.mapper = mapper;
    }

    shared actual
    List<Language> findAll()
        =>  CeylonList(mapper.findAll());
}
