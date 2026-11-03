#!/bin/sh

set -e

################################################################################
# repo
################################################################################
helm repo add skyhook https://skyhook-io.github.io/helm-charts
helm repo update > /dev/null

################################################################################
# chart
################################################################################
STACK="radar"
CHART="skyhook/radar"
CHART_VERSION="1.19.0"
NAMESPACE="radar"

if [ -z "${MP_KUBERNETES}" ]; then
  # use local version of values.yml
  ROOT_DIR=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
  values="$ROOT_DIR/stacks/radar/values.yml"
else
  # use github hosted master version of values.yml
  values="https://raw.githubusercontent.com/digitalocean/marketplace-kubernetes/master/stacks/radar/values.yml"
fi

helm upgrade "$STACK" "$CHART" \
  --atomic \
  --create-namespace \
  --install \
  --timeout 8m0s \
  --namespace "$NAMESPACE" \
  --values "$values" \
  --version "$CHART_VERSION"
