#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Minikube
install_minikube() {
    if ! command_exists minikube; then
        echo "Minikube is not installed. Installing Minikube..."
        curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        chmod +x minikube
        sudo mv minikube /usr/local/bin/
        echo "Minikube installation complete."
    else
        echo "Minikube is already installed."
    fi
}

# Install Kubectl
install_kubectl() {
    if ! command_exists kubectl; then
        echo "Kubectl is not installed. Installing kubectl..."
        curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/
        echo "Kubectl installation complete."
    else
        echo "Kubectl is already installed."
    fi
}

# Install Helm
install_helm() {
    if ! command_exists helm; then
        echo "Helm is not installed. Installing Helm..."
        curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
        echo "Helm installation complete."
    else
        echo "Helm is already installed."
    fi
}

# Install Terraform
install_terraform() {
    if ! command_exists terraform; then
        echo "Terraform is not installed. Installing Terraform..."
        sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /etc/apt/trusted.gpg.d/hashicorp.asc
        sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        sudo apt-get update && sudo apt-get install -y terraform
        echo "Terraform installation complete."
    else
        echo "Terraform is already installed."
    fi
}

# Start the installation of prerequisites
echo "Starting installation of prerequisites..."

install_minikube
install_kubectl
install_helm
install_terraform

echo "All prerequisites have been installed successfully."

# Optional: Verify installations
echo -e "\nVerifying installations..."
echo "Minikube version: $(minikube version)"
echo "Kubectl version: $(kubectl version --client --short)"
echo "Helm version: $(helm version --short)"
echo "Terraform version: $(terraform version)"

echo -e "\nPrerequisites installation completed."

# Start Minikube with desired resources
minikube start --cpus=2 --memory=4096

# Enable Nginx Ingress controller
minikube addons enable ingress

# Verify that Minikube started successfully
minikube status

terraform init

terraform apply --auto-approve

check_pods() {
  namespace=$1
  # Get all pods in the given namespace and check their status
  pods_status=$(kubectl get pods -n "$namespace" --no-headers | awk '{print $3}')
  
  # Check if all the pod statuses are 'Running'
  for status in $pods_status; do
    if [[ "$status" != "Running" ]]; then
      return 1  # Return 1 if any pod is not running
    fi
  done
  return 0  # Return 0 if all pods are running
}

# Wait until all pods are running
namespace="sonarqube"  # Set your namespace
echo "Waiting for all pods to be in Running state..."

while true; do
  if check_pods "$namespace"; then
    echo "All pods are Running!"
    break
  else
    echo "Some pods are still not running. Retrying in 10 seconds..."
    sleep 10
  fi
done

# After all pods are running, print success messages
echo "Environment has been deployed successfully!"