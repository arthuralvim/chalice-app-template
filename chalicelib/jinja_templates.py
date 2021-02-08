from chalice import Response
from jinja2 import ChoiceLoader
from jinja2 import Environment
from jinja2 import FileSystemLoader


jinja_env = Environment(
    loader=ChoiceLoader(
        [
            FileSystemLoader("chalicelib/templates"),
        ]
    )
)


def add_template_filter(f, name=None):
    jinja_env.filters[name or f.__name__] = f


def add_template_global(f, name=None):
    jinja_env.globals[name or f.__name__] = f


def render_template(template_path, **context):
    template = jinja_env.get_or_select_template(template_path)
    return template.render(context)


def render_to_response(template_path, **context):
    return Response(
        render_template(template_path, **context),
        status_code=200,
        headers={"Content-Type": "text/html", "Access-Control-Allow-Origin": "*"},
    )
