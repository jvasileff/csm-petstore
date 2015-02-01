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

transactional component inject
class AccountDaoImpl(AccountMapper mapper)
        extends BaseDao<Account, String>(mapper)
        satisfies AccountDao {

    shared actual
    List<Account> findAll()
        =>  CeylonList(mapper.findAll());
}
