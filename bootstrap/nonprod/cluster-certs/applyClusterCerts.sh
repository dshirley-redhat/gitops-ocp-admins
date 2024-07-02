#!/bin/bash

path=$1

echo "loading files from $path"

oc delete configmap custom-ca \
    -n openshift-config

oc delete secret mycert \
    -n openshift-ingress
    
oc delete secret argocd-server-tls \
    -n openshift-gitops

oc create configmap custom-ca \
    --from-file=ca-bundle.crt="$path"dshirley1ipi-ca.crt \
    --from-file=ca.crt="$path"dshirley1ipi-ca.crt \
    -n openshift-config

oc create secret tls mycert \
    --cert="$path"dshirley1ipi.crt --key="$path"dshirley1ipi.key \
    -n openshift-ingress

oc create secret tls argocd-server-tls \
    --cert="$path"dshirley1ipi.crt --key="$path"dshirley1ipi.key \
    -n openshift-gitops

oc patch proxy/cluster \
    --type=merge \
    --patch='{"spec":{"trustedCA":{"name":"custom-ca"}}}'

oc patch ingresscontroller.operator default \
    --type=merge -p \
    '{"spec":{"defaultCertificate": {"name": "mycert"}}}' \
    -n openshift-ingress-operator

oc patch oauth/cluster -p \
    '[{"op": "replace", "path": "/spec/identityProviders/0/openID/ca/name", "value":"custom-ca"}]' \
    --type=json

