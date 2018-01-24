.PHONY: all docs
.SILENT: banner help

TF_VERSION = 0.11.2

ifeq ($(origin AWS_ACCESS_KEY_ID), undefined)
$(error Environment variable AWS_ACCESS_KEY_ID needs to be defined)
endif

ifeq ($(origin AWS_SECRET_ACCESS_KEY), undefined)
$(error Environment variable AWS_SECRET_ACCESS_KEY needs to be defined)
endif

ifneq ("$(shell which terraform)","")
TF_PATH := $(shell which terraform)
else
TF_PATH = ./terraform
endif

ifeq ("${TF_PATH}", "./terraform")
  ifeq ("$(wildcard $(TF_PATH))", "")
    ifneq ("$(shell uname)", "Linux")
        $(error This only works on linux for now... pr welcome)
    endif
    BASE_URL = https://releases.hashicorp.com/terraform/${TF_VERSION}/
    ARCHIVE_FILE = terraform_${TF_VERSION}_linux_amd64.zip
    BOOTSTRAP_CMD := test ! -f ${TF_PATH} && curl -O ${BASE_URL}${ARCHIVE_FILE} && unzip ${ARCHIVE_FILE} && rm -f ${ARCHIVE_FILE}
  endif
endif

ifeq ($(origin BOOTSTRAP_CMD), undefined)
    BOOTSTRAP_CMD := echo "INFO: Using installed ${TF_PATH}"
endif

ifeq ($(origin LOCAL_PLUGINS_DIR), defined)
    PLUGIN_CMD := -get-plugins=false -plugin-dir=${LOCAL_PLUGINS_DIR}
endif


all: plan

help:   ## Show this help, includes list of all actions.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:.*##/\t/'

clean: ## Cleanup the workspace
	-rm -f *.zip terraform *.backup

plan: init  ## Run terraform plan using s3 sucket
	${TF_PATH} plan

test: plan ## Standard entry point for running tests. Calls plan

apply: init ## Run terraform apply
	${TF_PATH} apply

publish: apply ## standard entry point for posting results of building project. Calls apply

setup: ## Setup terraform command if necessary
	-${BOOTSTRAP_CMD}

init: ## Initalize shared storage bucket for state
	if [ ! -d .terraform ]; then ${TF_PATH} ${PLUGIN_CMD} init; else ${TF_PATH} get ;fi
