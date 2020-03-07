#!/usr/bin/env bash

# get onprem cluster Istio Ingress Gateway IP (GWIP)
GWIP_ONPREM=$(kubectl --context=onprem get -n istio-system service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
sed -i 's/GWIP_ONPREM/'$GWIP_ONPREM'/g' ./service-entries.yaml.tpl > ./gcp/service-entries.yaml