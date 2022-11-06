#!/bin/bash

sudo mkdir -p /mnt/kubernetes/vol

k3d cluster create bamboo \
--servers 1 --agents 1 \
--api-port 6550 \
--port 81:80@loadbalancer \
-- volume /mnt/kubernetes/vol:/mnt/kubernetes/vol

k3d kubeconfig get bamboo > config-bamboo
export KUBECONFIG=$PWD/config-bamboo

 
