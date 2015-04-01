import ceylon.language.meta.model {
    Attribute,
    Method
}

shared
interface InvocationHandler<Container>
        given Container satisfies Object {

    shared formal
    void setAttribute<Get, Set>(
            Container proxy,
            Attribute<Container, Get, Set> attribute,
            Set val);

    shared formal
    Get getAttribute<Get, Set>(
            Container  proxy,
            Attribute<Container, Get, Set> attribute);

    shared formal
    Return invoke<Return, Arguments>(
            Container proxy,
            Method<Container, Return, Arguments> method,
            Arguments arguments)
            given Arguments satisfies Anything[];
}

