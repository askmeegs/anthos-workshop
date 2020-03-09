#!/usr/bin/env bash

# Copyright 2019 Google LLC
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

echo "### "
echo "### Begin install istio control plane - ${CONTEXT}"
echo "### "


# Set vars for DIRs
export ISTIO_VERSION=1.5.0
export WORK_DIR=${WORK_DIR:="${PWD}/workdir"}
export ISTIO_DIR=$WORK_DIR/istio-$ISTIO_VERSION
export BASE_DIR=${BASE_DIR:="${PWD}/.."}
echo "BASE_DIR set to $BASE_DIR"
export ISTIO_CONFIG_DIR="$BASE_DIR/hybrid-multicluster/istio"

# Install Istio on ${CONTEXT}
kubectx ${CONTEXT}

# Prepare for install
kubectl create namespace istio-system
kubectl label namespace default istio-injection=enabled
kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=$(gcloud config get-value core/account)

alias istioctl=${WORKDIR}/istio-${ISTIO_VERSION}/bin/istioctl

# Create a secret with the sample certs for multicluster deployment
kubectl --context ${CONTEXT} create secret generic cacerts -n istio-system \
--from-file=${WORK_DIR}/istio-${ISTIO_VERSION}/samples/certs/ca-cert.pem \
--from-file=${WORK_DIR}/istio-${ISTIO_VERSION}/samples/certs/ca-key.pem \
--from-file=${WORK_DIR}/istio-${ISTIO_VERSION}/samples/certs/root-cert.pem \
--from-file=${WORK_DIR}/istio-${ISTIO_VERSION}/samples/certs/cert-chain.pem

# Install Istio with multi control plane enabled
istioctl manifest apply \
-f ${WORK_DIR}/istio-${ISTIO_VERSION}/install/kubernetes/operator/examples/multicluster/values-istio-multicluster-gateways.yaml \
--set values.grafana.enabled=true \
--set values.kiali.enabled=true \
--set values.tracing.enabled=true \
--set values.kiali.enabled=true --set values.kiali.createDemoSecret=true \
--set values.global.proxy.accessLogFile="/dev/stdout"

# install the Stackdriver adapter
git clone https://github.com/istio/installer && cd installer
helm template istio-telemetry/mixer-telemetry --execute=templates/stackdriver.yaml -f global.yaml --set mixer.adapters.stackdriver.enabled=true --namespace istio-system | kubectl apply -f -
cd ..
rm -rf installer/