from apps.core.exceptions import GenericException


class MissedUsernameOrEmailException(GenericException):
    code = 2000
    verbose = True

    def __init__(self, message=None):
        if not message:
            message = "Username or email is required."
        super().__init__(message=message)
