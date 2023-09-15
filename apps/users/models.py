import uuid

from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["username"]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(unique=True)
    phone = models.CharField(default="", blank=True, max_length=30)
    bio = models.CharField(default="", blank=True, max_length=1000)
    display_name = models.CharField(default="", blank=True, max_length=100)

    def __str__(self):
        return self.name

    @property
    def name(self):
        name = "%s %s" % (self.first_name, self.last_name)
        if not name.strip():
            name = self.username
        return name

    def get_display_name(self):
        if self.display_name:
            return self.display_name
        return self.name

    def save(self, *args, **kwargs):
        if not self.pk and not self.username:
            from allauth.utils import generate_unique_username

            self.username = generate_unique_username(
                [
                    self.first_name,
                    self.last_name,
                    self.email,
                    self.username,
                    "user",
                ]
            )

        self.first_name = " ".join(self.first_name.split())
        self.last_name = " ".join(self.last_name.split())

        return super().save(*args, **kwargs)
