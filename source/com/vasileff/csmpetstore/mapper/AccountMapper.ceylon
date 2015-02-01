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

component shared
interface AccountMapper satisfies Mapper<Account, String> {

    select({   "CREATE TABLE ACCOUNT (
                    username    VARCHAR(75) PRIMARY KEY,
                    full_name   VARCHAR(50) NOT NULL,
                    email       VARCHAR(75),
                    country     VARCHAR(50))"
    })
    shared formal
    void createTable();

    select({   "SELECT  username,
                        full_name,
                        email,
                        country
                FROM    account
                ORDER BY username"
    })
    shared formal
    JList<Account> findAll();

}
