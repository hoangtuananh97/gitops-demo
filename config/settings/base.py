"""
Django settings for api project.

For more information on this file, see
https://docs.djangoproject.com/en/2.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/2.0/ref/settings/
"""
import os

import environ  # noqa
import sentry_sdk
from django.utils.translation import gettext_lazy as _
from sentry_sdk.integrations.django import DjangoIntegration

from .logging import LOGGING  # noqa
from .swagger import SWAGGER_SETTINGS  # noqa

#
env = environ.Env()
env.read_env()

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROOT_DIR = environ.Path(__file__) - 3

BASE_URL = env("BASE_URL", default="http://localhost")

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/2.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = env(
    "DJANGO_SECRET_KEY",
    default="6n&fz#k_vf1bnmmb0h9u91gvr0+5mw9#$$b_a-@zcwr7vx)636",
)

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = env.bool("DEBUG", default=False)

APP_NAME = env.str("APP_NAME", default="my-app")

ALLOWED_HOSTS = env("DJANGO_ALLOWED_HOSTS", default=["*"])

# Application definition

DJANGO_APPS = (
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
)

THIRD_PARTY_APPS = (
    "rest_framework",
    # Auth
    "rest_framework.authtoken",
    "oauth2_provider",
    "dj_rest_auth",
    # Registration
    "django.contrib.sites",
    "allauth",
    "allauth.account",
    "allauth.socialaccount",
    "dj_rest_auth.registration",
    # CORS
    "corsheaders",
    # Swagger
    "drf_yasg",
    # Celery
    "django_celery_beat",
    "django_celery_results",
    # health check
    "health_check",
    "health_check.contrib.celery",
    "health_check.db",
    "health_check.cache",
    "health_check.storage",
)

# Apps specific for this project go here.
LOCAL_APPS = (
    "apps.core.apps.CoreConfig",
    "apps.users.apps.UserConfig",
)

# django-extensions
# ------------------------------------------------------------------------------
# https://django-extensions.readthedocs.io/en/latest/installation_instructions.html#configuration
EXTENSION_APPS = ("django_extensions",)  # noqa F405

INSTALLED_APPS = DJANGO_APPS + THIRD_PARTY_APPS + EXTENSION_APPS + LOCAL_APPS

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.locale.LocaleMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    "oauth2_provider.middleware.OAuth2TokenMiddleware",
]


FRONTEND_BASE_URL = env("FRONTEND_BASE_URL", default="http://localhost")

# Registration
SITE_ID = 1

# Mailer
EMAIL_BACKEND = env(
    "DJANGO_EMAIL_BACKEND",
    default="django.core.mail.backends.smtp.EmailBackend",
)
EMAIL_HOST = env("EMAIL_HOST", default="smtp.gmail.com")
EMAIL_HOST_USER = env("EMAIL_HOST_USER", default="")
EMAIL_HOST_PASSWORD = env("EMAIL_HOST_PASSWORD", default="")
EMAIL_PORT = env.int("EMAIL_PORT", default=587)
EMAIL_USE_TLS = env.bool("EMAIL_USE_TLS", default=True)
DEFAULT_FROM_EMAIL = env("DJANGO_DEFAULT_FROM_EMAIL", default="")
ACCOUNT_EMAIL_SUBJECT_PREFIX = env("ACCOUNT_EMAIL_SUBJECT_PREFIX", default="")

AUTHENTICATION_BACKENDS = (
    "oauth2_provider.backends.OAuth2Backend",
    # Uncomment following if you want to access the admin
    "django.contrib.auth.backends.ModelBackend",
)

# Auth model
AUTH_USER_MODEL = "users.User"

# Route
ROOT_URLCONF = "config.urls"

# Template
TEMPLATES_ROOT = str(ROOT_DIR("templates"))
TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [TEMPLATES_ROOT],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "config.wsgi.application"

# Database
# https://docs.djangoproject.com/en/2.0/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': 'db.sqlite3',
    }
}

# Internationalization
# https://docs.djangoproject.com/en/2.0/topics/i18n/
LANGUAGES = (("en-us", _("English")),)

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_L10N = True

USE_TZ = True

# Locale paths
LOCALE_PATHS = (os.path.join(ROOT_DIR, "locale"),)

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/2.0/howto/static-files/

# STATIC FILE CONFIGURATION
# ------------------------------------------------------------------------------
# See: https://docs.djangoproject.com/en/dev/ref/settings/#static-root
STATIC_ROOT = env.str("STATIC_ROOT", default=str(ROOT_DIR("static")))

# See: https://docs.djangoproject.com/en/dev/ref/settings/#static-url
STATIC_URL = "/static/"

# Media
MEDIA_ROOT = env.str("MEDIA_ROOT", default=str(ROOT_DIR("media")))
MEDIA_URL = env("MEDIA_URL", default="/media/")

REST_FRAMEWORK = {
    "COERCE_DECIMAL_TO_STRING": False,
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework.authentication.BasicAuthentication",
        "rest_framework.authentication.SessionAuthentication",
    ),
    "DEFAULT_PERMISSION_CLASSES": ("rest_framework.permissions.IsAuthenticated",),
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.LimitOffsetPagination",
    "PAGE_SIZE": env.int("PAGE_SIZE", 20),
    "PAGINATE_BY_PARAM": "page_size",  # Allow client to override, using `?page_size=xxx`.
    "MAX_PAGINATE_BY": 500,  # Maximum limit allowed when using `?page_size=xxx`.
    "EXCEPTION_HANDLER": "apps.core.exception_handler.api_exception_handler",
}


# whether or not cookies will be allowed to be included in cross-site HTTP requests
CORS_ALLOW_CREDENTIALS = True

# Allow CORS requests from all domain
# Should use CORS_ALLOWED_ORIGINS to whitelist domain instead
CORS_ALLOW_ALL_ORIGINS = True

CORS_ALLOW_HEADERS = (
    "accept",
    "accept-encoding",
    "authorization",
    "content-type",
    "dnt",
    "origin",
    "user-agent",
    "x-csrftoken",
    "x-requested-with",
    "device-id",
    "client-id",
    "app-version",
)

#  Celery
BROKER_URL = env("CELERY_BROKER_URL", default="django://")
CELERYD_MAX_TASKS_PER_CHILD = 100
CELERYD_TASK_SOFT_TIME_LIMIT = 2400  # 40 minutes
CELERY_RESULT_BACKEND = "django-db"
CELERY_IGNORE_RESULT = False

if "SENTRY_IO_DSN" in os.environ:
    sentry_sdk.init(
        dsn=env.str("SENTRY_IO_DSN"),
        integrations=[DjangoIntegration()],
        # If you wish to associate users to errors (assuming you are using
        # django.contrib.auth) you may enable sending PII data.
        send_default_pii=True,
    )
