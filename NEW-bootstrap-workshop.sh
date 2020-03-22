#!/usr/bin/env bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Variables

if [[ $OSTYPE == "linux-gnu" && $CLOUD_SHELL == true ]]; then

    export PROJECT=$(gcloud config get-value project)
    export BASE_DIR=${BASE_DIR:="${PWD}"}
    export WORK_DIR=${WORK_DIR:="${BASE_DIR}/workdir"}

    echo "WORK_DIR set to $WORK_DIR"
    gcloud config set project $PROJECT

    source ./common/settings.env
    ./common/install-tools.sh

    # enable apis
    echo "Enabling Anthos APIs... This may take up to 5 minutes."
    gcloud services enable \
    container.googleapis.com \
    compute.googleapis.com \
    stackdriver.googleapis.com \
    meshca.googleapis.com \
    meshtelemetry.googleapis.com \
    meshconfig.googleapis.com \
    iamcredentials.googleapis.com \
    anthos.googleapis.com \
    cloudresourcemanager.googleapis.com \
    gkeconnect.googleapis.com \
    gkehub.googleapis.com \
    serviceusage.googleapis.com \
    sourcerepo.googleapis.com

    # GKE
    ./gke/provision-gke1.sh
    ./gke/provision-gke2.sh

    # install single ctrl plane multicluster ASM (ctrl plane - gcp)
    PROJECT_ID=${PROJECT} ./asm/install-asm.sh

    # ACM pre-install
    kubectx gcp && ./config-management/install-config-operator.sh
    kubectx onprem && ./config-management/install-config-operator.sh
else
    echo "This has only been tested in GCP Cloud Shell.  Only Linux (debian) is supported".
fi
