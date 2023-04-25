#!/bin/bash
# Configure microk8s permissions
sudo usermod -a -G microk8s $(whoami)
microk8s config > \$HOME/.kube/config
sudo chown -R suspiro ~/.kube
newgrp microk8s

# Create an alias for kubectl to use microk8s kubectl
echo "alias kubectl='microk8s kubectl'" >> \$HOME/.bash_aliases
echo "alias helm='microk8s.helm'" >> \$HOME/.bash_aliases

# Enable required MicroK8s add-ons
microk8s enable dns helm3 dashboard 

# Source aliases
. \$HOME/.bash_aliases