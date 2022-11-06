#!/bin/bash

PG_USER=bamboo
PG_PASS=postgres
BAMBOO_USER=bamboo
BAMBOO_PASS=bamboo
BAMBOO_EMAIL=fake@mail.com

sudo mkdir -p /mnt/kubernetes/vol

k3d cluster create bamboo --servers 1 --agents 1 --api-port 6550 --port 81:80@loadbalancer --volume /mnt/kubernetes/vol:/mnt/kubernetes/vol

k3d kubeconfig get bamboo > config-bamboo
export KUBECONFIG=$PWD/config-bamboo

kubectl create secret generic pg-secret --from-literal=pg-user=$PG_USER --from-literal=pg-admin=$PG_PASS

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install postgresql bitnami/postgresql --version 12.1.0 -f bamboo.yml

kubectl create secret generic bamboo-secret --from-literal=bamboo-user=$BAMBOO_USER --from-literal=bamboo-pass=$BAMBOO_PASS --from-literal=bamboo-email=$BAMBOO_EMAIL

helm repo add atlassian-data-center https://atlassian.github.io/data-center-helm-charts
helm install bamboo atlassian-data-center/bamboo --version 1.7.1 -f bamboo.yml
 
