#!/bin/bash

# Update the apt package index
sudo apt update

# Install containerd and other dependencies
sudo apt install -y containerd apt-transport-https ca-certificates curl

# Disable swap
sudo swapoff -a

# Prepare containerd config
sudo mkdir /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml $ >/dev/null
sudo sed -i "s/SystemdCgroup = false/SystemdCgroup = true/" /etc/containerd/config.toml

# Enable bridging
sudo sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/" /etc/sysctl.conf

# Enable br_netfilter
sudo echo "br_netfilter" >/etc/modules-load.d/k8s.conf

# Install Kubernetes tools
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubeadm kubelet kubectl
sudo apt-mark hold kubelet kubeadm kubectl
