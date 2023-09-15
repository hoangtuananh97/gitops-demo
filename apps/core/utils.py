# type: ignore
import logging
from logging import Logger
from typing import Optional

logger = logging.getLogger(__name__)


def get_logger(name: Optional[str] = "django") -> Logger:
    return logging.getLogger(name)
