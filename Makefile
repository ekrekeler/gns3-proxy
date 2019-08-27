SHELL := /bin/bash

NS ?= flex
IMAGE_NAME ?= gns3-proxy
VERSION ?= v0.5
LATEST_TAG := $(NS)/$(IMAGE_NAME):latest
IMAGE_TAG := $(NS)/$(IMAGE_NAME):$(VERSION)

.PHONY: all clean test package test-release release coverage flake8 container run-container release-container

all: clean test

clean:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	rm -f .coverage
	rm -rf htmlcov
	rm -rf dist

test:
	python tests.py -v

package: clean
	python setup.py sdist bdist_wheel

test-release: package
	twine upload --repository-url https://test.pypi.org/legacy/ dist/*

release: package
	twine upload dist/*

coverage:
	coverage run tests.py
	coverage html

flake8:
	flake8 --ignore=E501,W504 --builtins="unicode" gns3_proxy.py
	flake8 --ignore=E501,W504 tests.py

container:
	docker build -t $(LATEST_TAG) -t $(IMAGE_TAG) .

run-container:
	docker run -it -p 14080:14080 --rm $(LATEST_TAG)

release-container:
	docker push $(IMAGE_TAG)
