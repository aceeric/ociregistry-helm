.PHONY : all
all: helm-docs helm-package helm-index

.PHONY: helm-docs
helm-docs:
	helm-docs

.PHONY: helm-package
helm-package:
	helm package ociregistry

.PHONY: helm-index
helm-index:
	helm repo index --url https://ericace.github.io/ociregistry-helm/ .
