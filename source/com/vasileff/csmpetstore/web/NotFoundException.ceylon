shared
class NotFoundException(
        description = null, cause = null)
        extends Exception(description, cause) {

    "A description of the problem."
    String? description;

    "The underlying cause of this exception."
    Throwable? cause;
}
