# Initialize the Kubernetes cluster
sudo kubeadm init --control-plane-endpoint=$(hostname -I) --node-name $(hostname) --pod-network-cidr=10.243.0.0/16 >install-output.txt

# Copy the kubeconfig file to the current user's home directory
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Sleep for 10 seconds...
echo "Waiting 10 seconds for the cluster to boot..."
sleep 10

# Install the Flannel pod network add-on
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

sudo bash -c "cat > /run/flannel/subnet.env" <<EOL
FLANNEL_NETWORK=10.243.0.0/16
FLANNEL_SUBNET=10.243.0.1/24
FLANNEL_MTU=1450
FLANNEL_IPMASQ=true
EOL

# Print the kubeadm join command to join worker nodes to the cluster
echo "To add worker nodes to the cluster, run the following command on each worker node:"
echo "sudo kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>"
