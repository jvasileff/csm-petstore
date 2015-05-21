import ceylon.interop.java {
    CeylonList
}

import com.vasileff.csmpetstore.domain {
    Language,
    languageOf
}
import com.vasileff.csmpetstore.mapper {
    LanguageMapper
}

import javax.annotation {
    postConstruct
}
import javax.inject {
    inject=inject__SETTER
}

import org.springframework.stereotype {
    repository
}
import org.springframework.transaction.annotation {
    transactional
}

shared
interface Repository {
    shared formal void insertRows();
    shared formal void deleteRows(Boolean fail);
    shared formal List<Language> selectRows();
}

shared transactional repository
class RepositoryDefault() satisfies Repository {

    shared late inject
    LanguageMapper languageMapper;

    shared postConstruct
    void initialize()
        =>  languageMapper.initialize();

    shared actual
    List<Language> selectRows()
        =>  CeylonList(languageMapper.findAll());

    shared actual
    void insertRows() {
        languageMapper.create(languageOf(1, "Ceylon"));
        languageMapper.create(languageOf(2, "Groovy"));
        languageMapper.create(languageOf(3, "Jacl"));
    }

    shared actual
    void deleteRows(Boolean fail) {
        for (language in CeylonList(languageMapper.findAll())) {
            languageMapper.delete(language.id);
        }
        if (fail) {
            throw; // trigger rollback
        }
    }
}
