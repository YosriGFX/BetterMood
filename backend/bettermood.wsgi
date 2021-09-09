import sys
flaskfirst = "/var/www/bettermood"
if not flaskfirst in sys.path:
    sys.path.insert(0, flaskfirst)

from app import app
application = app
