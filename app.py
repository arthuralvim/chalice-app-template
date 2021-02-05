from chalice import Chalice
from chalice import Response
from decouple import config

from chalicelib.apps import cron_routes
from chalicelib.apps import dashboards_routes

app = Chalice(app_name="chalice-app-template")
app.debug = config("DEBUG", default=True, cast=bool)
run_cron = config("RUN_CRON", default=False, cast=bool)
app.log.setLevel(config("LOG_LEVEL", default="DEBUG"))

app.register_blueprint(dashboards_routes)

if run_cron:
    app.register_blueprint(cron_routes)


@app.route("/")
def index():
    return Response(body={"running": "ok"}, status_code=200, headers={"Content-Type": "application/json"})
