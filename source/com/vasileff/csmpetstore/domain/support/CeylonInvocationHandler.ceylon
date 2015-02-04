import ceylon.language.meta.model {
    Attribute,
    Method
}

shared interface CeylonInvocationHandler<Container> {

    shared formal
    void setAttribute(
            Container? proxy,
            Attribute<Container> attribute,
            Anything val);

    shared formal
    Anything getAttribute(
            Container? proxy,
            Attribute<Container> attribute);

    shared formal
    Anything invoke(
            Container? proxy,
            Method<Container> method,
            {Anything*} arguments);

}