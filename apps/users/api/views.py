from drf_yasg.utils import swagger_auto_schema
from rest_framework import generics, status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.users.api import serializers


class UserProfileView(generics.RetrieveUpdateAPIView):
    serializer_class = serializers.UserSerializer

    def get_object(self):
        return self.request.user


class UserExistView(APIView):
    permission_classes = (AllowAny,)

    @swagger_auto_schema(
        operation_summary="check exist email or username",
        operation_id="username_email_exist",
        security=[],
    )
    def get(self, request, *args, **kwargs):
        data = {"exists": True}
        return Response(data, status=status.HTTP_200_OK)
