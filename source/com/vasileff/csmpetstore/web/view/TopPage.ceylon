shared abstract
class TopPage(shared String name, shared String url)
        of home | about | contact | login {}

shared object login extends TopPage("Login", "login") {}
shared object home extends TopPage("Home", "welcome") {}
shared object about extends TopPage("About", "about") {}
shared object contact extends TopPage("Contact", "contact") {}
