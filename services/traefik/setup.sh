#!/bin/bash
# Add MicroK8s setup commands here
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik -f traefik-values.yaml
