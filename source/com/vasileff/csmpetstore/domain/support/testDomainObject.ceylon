import ceylon.collection {
    ArrayList
}

shared
void testDomainObject() {

    Account2 account = createDomainObject(`Account2`);
    print(account.primaryKeySet());
    account.username = "jvasileff";
    print(account.username);
    print(account.getPK());
    print(account.isSet(`Account2.username`));
    print(account.isSet(`Account2.username`, `Account2.email`));
    print(account.isSet(`Account2.email`));
    print(account.isSet());
    print(account.isUpdated());
    print(account.isUpdated(`Account2.username`));
    print(account.isUpdated(`Account2.username`, `Account2.email`));
    print(account.isUpdated(`Account2.email`));
    account.clearUpdated();

    List<Account2> list = ArrayList { createDomainObject(`Account2`) };
    value x = list.first;
    switch(x)
    case (is Account2) {
        print ("yes, is account2");
    }
    case (is Null) {
        print ("null");
    }

}
