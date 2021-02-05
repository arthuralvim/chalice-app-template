import sys
from pathlib import Path

import pytest

package_path = str(Path(__file__).parent.parent)
sys.path.insert(0, f"{package_path}/vendor")
sys.path.insert(0, package_path)

from app import app  # noqa


@pytest.fixture
def gateway_factory():
    from chalice.config import Config
    from chalice.local import LocalGateway

    def create_gateway(config=None):
        if config is None:
            config = Config()
        return LocalGateway(app, config)

    return create_gateway
