# Makefile chalice-app-template

# These targets are not files
.PHONY: all help check.app_stage check.test_path clean clean-build clean-others clean-pyc clean-test deploy requirements test test.collect

all: help

help:
	@echo '*** Basic Makefile for chalice-app-template ***'

check.test_path:
	@if test "$(TEST_PATH)" = "" ; then echo "TEST_PATH is undefined."; fi

check.app_stage:
	@if test "$(APP_STAGE)" = "" ; then echo "APP_STAGE is undefined."; exit 1; fi

requirements:
	@poetry export -f requirements.txt --without-hashes --output requirements.txt

clean: clean-build clean-others clean-pyc clean-test

clean-build:
	@rm -fr build/
	@rm -fr dist/
	@rm -fr .eggs/
	@find . -name '*.egg-info' -exec rm -fr {} +
	@find . -name '*.egg' -exec rm -f {} +

clean-others:
	@find . -name 'Thumbs.db' -exec rm -f {} +

clean-pyc:
	@find . -name '*.pyc' -exec rm -f {} +
	@find . -name '*.pyo' -exec rm -f {} +
	@find . -name '*~' -exec rm -f {} +
	@find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	@rm -fr .tox/
	@rm -f .coverage
	@rm -fr htmlcov/

test: check.test_path
	@poetry run pytest -c pyproject.toml $(TEST_PATH) --cov --cov-report term-missing --basetemp=tests/media --disable-pytest-warnings

test.collect: check.test_path
	@poetry run pytest -c pyproject.toml --collect-only --disable-pytest-warnings

config_encrypt: check.app_stage
	@poetry run ansible-vault encrypt --vault-password-file=.password-file.vault \
		.chalice/config-${APP_STAGE}.json --output=.chalice/config-${APP_STAGE}.json.vault
	@rm .chalice/config-${APP_STAGE}.json

config_decrypt: check.app_stage
	@poetry run ansible-vault decrypt --vault-password-file=.password-file.vault \
		.chalice/config-${APP_STAGE}.json.vault --output=.chalice/config.json

config_edit: check.app_stage
	@poetry run ansible-vault edit --vault-password-file=.password-file.vault .chalice/config-${APP_STAGE}.json.vault

deployed_encrypt: check.app_stage
	@poetry run ansible-vault encrypt --vault-password-file=.password-file.vault \
		.chalice/deployed/${APP_STAGE}.json --output=.chalice/deployed/${APP_STAGE}.json.vault
	@rm .chalice/deployed/${APP_STAGE}.json

deployed_decrypt: check.app_stage
	@poetry run ansible-vault decrypt --vault-password-file=.password-file.vault \
		.chalice/deployed/${APP_STAGE}.json.vault --output=.chalice/deployed/${APP_STAGE}.json

deployed_edit: check.app_stage
	@poetry run ansible-vault edit --vault-password-file=.password-file.vault .chalice/deployed/${APP_STAGE}.json


deploy: check.app_stage config_decrypt deployed_decrypt
	@echo ">> Deploying to ${APP_STAGE} <<"
	@poetry run chalice deploy --stage ${APP_STAGE}
	@poetry run chalice url --stage ${APP_STAGE}
