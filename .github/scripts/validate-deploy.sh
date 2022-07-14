#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

export KUBECONFIG=$(cat .kubeconfig)

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

## ***** Instance

NAMESPACE="gitops-cp-datapower"
BRANCH="main"
SERVER_NAME="default"
TYPE="instances"

COMPONENT_NAME="ibm-datapower-instance"

if [[ ! -f "argocd/2-services/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml" ]]; then
  echo "ArgoCD config missing - argocd/2-services/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
  exit 1
fi

echo "Printing argocd/2-services/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
cat "argocd/2-services/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"

if [[ ! -f "payload/2-services/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml" ]]; then
  echo "Application values not found - payload/2-services/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"
  exit 1
fi

echo "Printing payload/2-services/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"
cat "payload/2-services/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"

cd ..
rm -rf .testrepo

INSTANCE_NAME="dp"
CR="datapowerservice/${INSTANCE_NAME}"
count=0
until kubectl get "${CR}" -n "${NAMESPACE}" || [[ $count -eq 10 ]]; do
  echo "Waiting for ${CR} in ${NAMESPACE}"
  count=$((count + 1))
  sleep 60
done

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for ${CR} in ${NAMESPACE}"
  kubectl get datapowerservice -n "${NAMESPACE}"
  exit 1
fi

count=0
until [[ $(kubectl get sts -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${NAMESPACE}-${INSTANCE_NAME}" | wc -l) -gt 0 ]] || [[ $count -eq 20 ]]; do
  echo "Waiting for statefulset in ${NAMESPACE} with label app.kubernetes.io/instance=${NAMESPACE}-${INSTANCE_NAME}"
  count=$((count + 1))
  sleep 60
done

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for statefulset in ${NAMESPACE} with label app.kubernetes.io/instance=${NAMESPACE}-${INSTANCE_NAME}"
  kubectl get sts -n "${NAMESPACE}"
  exit 1
fi

STS_NAME=$(kubectl get sts -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${NAMESPACE}-${INSTANCE_NAME}" -o jsonpath='{range .items[]}{.metadata.name}{"\n"}{end}')
echo "Waiting for statefulset rollout: ${STS_NAME}"
oc rollout status sts "${STS_NAME}" -n "${NAMESPACE}" --timeout=10m
