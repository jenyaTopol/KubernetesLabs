#!/bin/bash

# Print out all messages 
set -x

# Hack to fix GCP console docker problem
rm -rf ~/.docker

# Make sure minikube is running 
# the script below will check and will start minikube if required
chmod +x ../../scripts/*.sh
# source ../../scripts/startMinikube.sh 

# Set the desired Istio version to download and install
export ISTIO_VERSION=1.12.2

# Download Istio with the specific verison
curl -L https://istio.io/downloadIstio | \
      ISTIO_VERSION=$ISTIO_VERSION \
      TARGET_ARCH=arm64 \
      sh -

# Set the Istio home, we will use this home for the installation
export ISTIO_HOME=${PWD}/istio-${ISTIO_VERSION}

# Add the cli to the path
export PATH="$PATH:${ISTIO_HOME}/bin"

# Check if our cluster is ready for istio
istioctl x precheck 

# For this installation, we use the demo configuration profile
# Istio support different profiles
# istioctl install --set profile=demo -y

# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
# kubectl create namespace istio-system
# helm install istio-base istio/base -n istio-system
# helm install istiod istio/istiod -n istio-system --wait

# Install kiali server
helm install \
  --namespace   istio-system \
  --set         auth.strategy="anonymous" \
  --repo        https://kiali.org/helm-charts \
  kiali-server \
  kiali-server

# Deploy our first demo 
cd ./01-demo-services/
# Build and deploy the resources
kubectl kustomize ./K8S | kubectl apply -f - 
cd ..

# install istio addons 
kubectl apply -f ${ISTIO_HOME}/samples/addons/prometheus.yaml
kubectl apply -f ${ISTIO_HOME}/samples/addons/grafana.yaml

# Set defaulalt namespace for our demo
kubectl config set-context --current --namespace codewizard

# Add istio label for injecting sidecars
# This is crucial or otherwise we will not be using istio in our namespace
# We have to add the istion label
# -- Reference: https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/#automatic-sidecar-injection
kubectl label ns codewizard istio-injection=enabled

# Verify that we have the label attached
# alterantive verification: 
#       kubectl get ns --show-labels
kubectl get namespace -L istio-injection

# We need to wait until the Kiali pod is up and runnig 
kubectl wait --for=condition=ready pod -l app=kiali -n istio-system

# Wait for our pods to be up and running
kubectl wait --for=condition=ready pod -l app=webserverv1 -l version=v1 -n codewizard

# Simulate traffic for this demo
source ./simulateTraffic.sh &

# Port forward for kiali gui.
# Extract the Kiali pod name
kubectl port-forward \
        -n istio-system \
        $(kubectl get pods -n istio-system --selector=app=kiali -o jsonpath='{$.items[*].metadata.name}') \
        20001:20001 &