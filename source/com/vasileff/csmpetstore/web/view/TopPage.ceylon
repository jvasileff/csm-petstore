shared abstract
class TopPage(shared String name, shared String url)
        of home | about | contact {}

shared object home extends TopPage("Home", "welcome") {}
shared object about extends TopPage("About", "about") {}
shared object contact extends TopPage("Contact", "contact") {}
