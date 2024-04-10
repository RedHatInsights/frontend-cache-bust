#!/bin/bash


set -exv

if [[ -z "$QUAY_USER" || -z "$QUAY_TOKEN" ]]; then
    echo "QUAY_USER and QUAY_TOKEN must be set"
    exit 1
fi

if [[ -z "$RH_REGISTRY_USER" || -z "$RH_REGISTRY_TOKEN" ]]; then
    echo "RH_REGISTRY_USER and RH_REGISTRY_TOKEN must be set"
    exit 1
fi

function cleanup() {

    if [[ -z "$TEARDOWN_RAN" ]]; then
        rm -fr "$TMP_JOB_DIR"
        TEARDOWN_RAN='yes'
    fi
}
TEARDOWN_RAN=''
PR_CHECK_BUILD=${PR_CHECK_BUILD:-}
IMAGE="quay.io/cloudservices/frontend-cache-bust"
TMP_DIR=$(mktemp -d -p "$HOME" -t "jenkins-${JOB_NAME}-${BUILD_NUMBER}-XXXXXX")
DOCKER_CONFIG="${TMP_DIR}/.docker"
mkdir "$DOCKER_CONFIG"
export DOCKER_CONFIG

trap cleanup EXIT ERR SIGINT SIGTERM

docker login -u="$QUAY_USER" --password-stdin quay.io <<< "$QUAY_TOKEN" 
docker login -u="$RH_REGISTRY_USER" --password-stdin registry.redhat.io <<< "$RH_REGISTRY_TOKEN"

if [[ -z "$PR_CHECK_BUILD" ]]; then
    IMAGE_TAG="pr-${ghprbPullId}-$(git rev-parse --short=7 HEAD)"
    docker build -t "${IMAGE}:${IMAGE_TAG}" --label 'quay.expires-after=3d' .
else
    IMAGE_TAG=$(git rev-parse --short=7 HEAD)
    docker build -t "${IMAGE}:${IMAGE_TAG}" .
fi

docker push "${IMAGE}:${IMAGE_TAG}"
