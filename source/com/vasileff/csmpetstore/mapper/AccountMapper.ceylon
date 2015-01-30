import com.vasileff.csmpetstore.domain {
    Account
}

import java.util {
    JList=List
}

import org.apache.ibatis.annotations {
    select
}
import org.springframework.stereotype {
    component
}

component shared interface AccountMapper
        satisfies PSMapper<Account, String> {

    select({
       "create table account(
            username    varchar(75) primary key,
            full_name   varchar(50) not null,
            email       varchar(75),
            country     varchar(50)
        )"})
    shared formal void createTable();

    select({
       "select  username,
                full_name,
                email,
                country
        from    account"})
    shared formal JList<Account> findAll();

}
