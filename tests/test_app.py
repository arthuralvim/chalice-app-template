import json


class TestChalice(object):
    def test_index(self, gateway_factory):
        gateway = gateway_factory()
        response = gateway.handle_request(method="GET", path="/", headers={}, body="")
        assert response["statusCode"] == 200
        assert json.loads(response["body"]) == dict([("running", "ok")])
