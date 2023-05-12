# Initialize the Kubernetes cluster
sudo kubeadm init --control-plane-endpoint=$(hostname -I) --node-name $(hostname) --pod-network-cidr=10.243.0.0/16 >install-output.txt

# Copy the kubeconfig file to the current user's home directory
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install the Flannel pod network add-on
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Print the kubeadm join command to join worker nodes to the cluster
echo "To add worker nodes to the cluster, run the following command on each worker node:"
echo "sudo kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>"
