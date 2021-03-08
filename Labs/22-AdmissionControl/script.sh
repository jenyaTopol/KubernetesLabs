#!/bin/bash

# start minikube if required
# minikube start

# Install telepresence
# curl -s https://packagecloud.io/install/repositories/datawireio/telepresence/script.deb.sh | sudo bash
# sudo apt install -y --no-install-recommends telepresence

# GCP Hack
rm -rf ~/.docker

# Define the certificates folder
export CERT_FOLDER=${PWD}/certs

# Verify the certs folder
mkdir -p ${CERT_FOLDER}

# 01. Create the CA key and certificate:
openssl     req         \
            -new        \
            -x509       \
            -nodes      \
            -days       3650 \
            -subj       '/CN=codewizard' \
            -keyout     ${CERT_FOLDER}/ca.key \
            -out        ${CERT_FOLDER}/ca.crt

# 02. Create the server key:
openssl     genrsa      \
            -out        ${CERT_FOLDER}/tls.key \
            2048        

# 03. Create a certificate signing request:
openssl     req         \
            -new        \
            -subj       '/CN=codewizard.default.svc' \
            -key        ${CERT_FOLDER}/tls.key \
            -out        ${CERT_FOLDER}/tls.csr

# 04. Create the server certificate:
openssl     x509        \
            -CAcreateserial \
            -req        \
            -days       3650 \
            -in         ${CERT_FOLDER}/tls.csr \
            -CA         ${CERT_FOLDER}/ca.crt \
            -CAkey      ${CERT_FOLDER}/ca.key \
            -out        ${CERT_FOLDER}/tls.crt

# Copy the certificates to tje K8S folder so it can be 
# used as secret for the deploymnets
cp -R ${CERT_FOLDER} ./k8s

# Build the required image
docker-compose build --no-cache

# Push the image to docker-hub
docker-compose push

# Deploy the resources to the cluster
kubectl kustomize ./k8s/ | kubectl apply -f -

# # Test the server
kubectl run tmp                 \
        -it --rm                \
        --image=busybox         \
        --restart=Never         \
        -v "./certs:/certs"     \
        -- sh -c "wget --ca-certificate=certs/ca.crt -O - -q -T 3 https://codewizard-service.codewizard.svc.cluster.local:3000"
                                                                