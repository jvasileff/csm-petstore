import ceylon.collection {
    ArrayList
}

shared
void testDomainObject() {

    User user = createDomainObject(`User`);
    print(user.isPrimaryKeySet());
    user.username = "jvasileff";
    print(user.username);
    print(user.primaryKey());
    print(user.isSet(`User.username`));
    print(user.isSet(`User.username`, `User.email`));
    print(user.isSet(`User.email`));
    print(user.isSet());
    print(user.isUpdated());
    print(user.isUpdated(`User.username`));
    print(user.isUpdated(`User.username`, `User.email`));
    print(user.isUpdated(`User.email`));
    user.clearUpdated();
    List<User> list = ArrayList { createDomainObject(`User`) };
    value x = list.first;
    switch(x)
    case (is User) {
        print ("yes, is account2");
    }
    case (is Null) {
        print ("null");
    }

}
