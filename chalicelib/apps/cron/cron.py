from chalice import Blueprint
from chalice import Rate


cron_routes = Blueprint(__name__)


# Automatically runs every 5 minutes
@cron_routes.schedule(Rate(5, unit=Rate.MINUTES))
def periodic_task(event):
    return {"hello-world": event}
