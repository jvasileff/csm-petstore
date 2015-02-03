import ceylon.html {
    Th,
    Td,
    Tr,
    Table
}

Table table(
    {String*} classNames = {},
    {String*}? header = null,
    {{String?*}*}? rows = null) {

    return Table {
        classNames = ["table", *classNames];
        header = header?.map((entry) => Th(entry)) else {};
        rows = rows?.map((row) => Tr {
            row.map((cell) => Td(cell else ""))
        }) else {};
    };
}