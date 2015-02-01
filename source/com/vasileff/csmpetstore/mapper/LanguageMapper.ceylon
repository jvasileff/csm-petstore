import java.util {
    JList=List
}

import org.springframework.stereotype {
    component
}

import com.vasileff.csmpetstore.domain {
    Language
}
import org.apache.ibatis.annotations {
    select
}

component shared
interface LanguageMapper satisfies Mapper<Language, Integer> {

    select({
       "CREATE TABLE jvm_langs (
            id      BIGINT PRIMARY KEY,
            name    VARCHAR(100)
        )"})
    shared formal
    void initialize();

    select({
       "SELECT  id,
                name
        FROM    jvm_langs"})
    shared formal
    JList<Language> findAll();

}
