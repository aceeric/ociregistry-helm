.PHONY : all
all: helm-docs helm-package

.PHONY: helm-docs
helm-docs:
	helm-docs

.PHONY: helm-package
helm-package:
	helm package ociregistry

