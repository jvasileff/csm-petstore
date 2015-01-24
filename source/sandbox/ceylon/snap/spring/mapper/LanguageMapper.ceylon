import java.util {
    JList=List
}

import org.apache.ibatis.annotations {
    select,
    insert,
    update,
    delete,
    resultType
}
import org.springframework.stereotype {
    component
}

import sandbox.ceylon.snap.spring.domain {
    Language
}

component shared interface LanguageMapper satisfies PSMapper<Language, Integer> {

    select({"create table jvm_langs(
                id bigint primary key,
                name varchar(100))"})
    shared formal void initialize();

    select({"select id, name from jvm_langs"})
    resultType(`Language`)
    shared formal JList<Language> findAll();

    //select({"select id, name from jvm_langs"})
    //resultType(`Language`)
    //shared formal Integer findAll2(ResultHandler handler);

    select({"select id, name from jvm_langs where id = ?"})
    shared actual formal Language? findByPK(Integer id);

    insert({"insert into jvm_langs (id, name)
             values (#{id,jdbcType=NUMERIC}, #{name,jdbcType=VARCHAR})"})
    shared actual formal Integer create(Language language);

    update({"update jvm_langs set name = #{name,jdbcType=VARCHAR}
             where id = #{id,jdbcType=NUMERIC}"})
    shared actual formal Integer update(Language language);

    delete({"delete from jvm_langs
             where id = #{id,jdbcType=NUMERIC}"})
    shared actual formal Integer delete(Integer id);
}
