# Initialize the Kubernetes cluster
sudo kubeadm init --control-plane-endpoint=$(hostname -I) --node-name $(hostname) --pod-network-cidr=10.244.0.0/16

# Copy the kubeconfig file to the current user's home directory
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Sleep for 10 seconds...
echo "Waiting 10 seconds for the cluster to boot..."
sleep 10

# Install the Flannel pod network add-on
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Remove taint for single node
read -n1 -p "Want to use this cluster with a single node?[N/y]" single_node
case $single_node in
y | Y) kubectl taint node $(hostname) node-role.kubernetes.io/control-plane:NoSchedule- &>/dev/null ;;
*) echo The taint has not been removed ;;
esac

# Print the kubeadm join command to join worker nodes to the cluster
echo "To add worker nodes to the cluster, run the following command on each worker node:"
echo "sudo kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>"
