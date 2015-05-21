import ceylon.interop.java {
    CeylonList
}

import com.vasileff.csmpetstore.domain {
    Account
}
import com.vasileff.csmpetstore.mapper {
    AccountMapper
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

shared
interface AccountDao satisfies PSDao<Account, String> {
    shared formal
    List<Account> findAll();
}

transactional component
class AccountDaoImpl
        extends BaseDao<Account, String>
        satisfies AccountDao {

    AccountMapper mapper;

    // PITA: have to use explicit constructor in order to use 'inject'
    shared inject
    new(AccountMapper mapper)
            extends BaseDao<Account, String>(mapper) {
        this.mapper = mapper;
    }

    shared actual
    List<Account> findAll()
        =>  CeylonList(mapper.findAll());
}
