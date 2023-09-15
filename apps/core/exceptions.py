from rest_framework import status
from rest_framework.exceptions import APIException


class GenericException(APIException):
    status_code = status.HTTP_400_BAD_REQUEST

    code = 1000
    summary = "Error"
    verbose = False
    error_detail = None

    def __init__(self, message=None, status_code=400, error_detail=None):
        if not message:
            message = "Oops! Something went wrong, please try again"
        if status_code:
            self.status_code = status_code
        if error_detail:
            self.error_detail = error_detail
        super().__init__(message)

    def serialize(self):
        data = {
            "status_code": self.status_code,
            "code": self.code,
            "summary": self.summary,
            "message": self.detail,
        }

        if self.error_detail:
            data.update({"error_detail": self.error_detail})
        return data


class InvalidDataException(GenericException):
    code = 1001
    verbose = True

    def __init__(self, message=None, field=None, error_detail=None, status_code=None, code=None):
        if not message:
            message = f"Input {field} error."
        if code:
            self.code = code
        super().__init__(message=message, error_detail=error_detail, status_code=status_code)


class ParseJsonErrorException(GenericException):
    code = 1002
    verbose = True

    def __init__(self, message=None):
        if not message:
            message = "JSON parse error."
        super().__init__(message=message)


class UnauthorizedException(GenericException):
    code = 1003
    verbose = True

    def __init__(self, message=None, status_code=401):
        if not message:
            message = "You need to login into the system to use this function."
        super().__init__(message=message, status_code=status_code)
