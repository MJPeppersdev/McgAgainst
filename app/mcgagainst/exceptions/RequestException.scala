package mcgagainst.exceptions

import mcgagainst.models.Errors.ErrorDetails

trait RequestException extends Exception {
    def statusCode: Int
    def details: ErrorDetails
}
