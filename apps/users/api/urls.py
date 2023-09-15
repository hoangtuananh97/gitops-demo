from django.urls import path

from apps.users.api import views

urlpatterns = [
    path("me/", views.UserProfileView.as_view(), name="me"),
    path("exists/", views.UserExistView.as_view(), name="user-exists"),
]
