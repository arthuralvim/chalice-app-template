from chalice import Blueprint

from chalicelib.jinja_templates import render_to_response


dashboards_routes = Blueprint(__name__)


@dashboards_routes.route("/dashboard", methods=["GET", "POST"])
def dashboard():
    context = {"hello": "world"}
    return render_to_response("base.html", **context)
