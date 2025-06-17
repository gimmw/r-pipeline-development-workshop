from datetime import timedelta

from flask import Flask, session
from superset.utils.core import NO_TIME_RANGE

FEATURE_FLAGS = {
	"ENABLE_TEMPLATE_PROCESSING": True,
}

ENABLE_PROXY_FIX = True
WTF_CSRF_ENABLED = False

SECRET_KEY = "SECRET_KEY"
PUBLIC_ROLE_LIKE = "Gamma"

ROW_LIMIT = 5000
SAMPLES_ROW_LIMIT = 1000
NATIVE_FILTER_DEFAULT_ROW_LIMIT = 1000
FILTER_SELECT_ROW_LIMIT = 10000
DEFAULT_TIME_FILTER = NO_TIME_RANGE

PROFILING = True
SHOW_STACKTRACE = True

PERMANENT_SESSION_LIFETIME = timedelta(hours=24)


def make_session_permanent() -> None:
	"""
	Enable maxAge for the cookie 'session'
	"""
	session.permanent = True


def FLASK_APP_MUTATOR(app: Flask) -> None:
	app.before_request_funcs.setdefault(None, []).append(make_session_permanent)
