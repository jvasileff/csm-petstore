import java.util {
    JList=List
}

import org.springframework.stereotype {
    component
}

import sandbox.ceylon.snap.spring.domain {
    Language
}
import org.apache.ibatis.annotations {
    select
}

component shared interface LanguageMapper
        satisfies PSMapper<Language, Integer> {

    select({
       "create table jvm_langs(
        id      bigint primary key,
        name    varchar(100))"})
    shared formal void initialize();

    select({
       "select  id,
                name
        from    jvm_langs"})
    shared formal JList<Language> findAll();

}
