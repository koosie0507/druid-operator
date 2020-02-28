#!/bin/bash

# Setup Service Account
kubectl create -f deploy/service_account.yaml
# Setup RBAC
kubectl create -f deploy/role.yaml
kubectl create -f deploy/role_binding.yaml
# Setup the CRD
kubectl create -f deploy/crds/druid.apache.org_druids_crd.yaml

# Update the operator manifest to use the druid-operator image name
case ${OSTYPE} in
    darwin*)
        sed -i "" 's|REPLACE_IMAGE|druidio/druid-operator:0.0.1|g' deploy/operator.yaml
        ;;
    *)
        sed -i 's|REPLACE_IMAGE|druidio/druid-operator:0.0.1|g' deploy/operator.yaml
        ;;
esac

# Deploy the druid-operator
kubectl create -f deploy/operator.yaml

# Check the deployed druid-operator
kubectl describe deployment druid-operator