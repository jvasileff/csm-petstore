abstract
class TopPage(shared String name, shared String url)
        of home | about | contact {}

object home extends TopPage("Home", "welcome") {}
object about extends TopPage("About", "about") {}
object contact extends TopPage("Contact", "contact") {}
