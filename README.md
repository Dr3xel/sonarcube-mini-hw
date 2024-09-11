## **SonarCube Mini HW**

This project automates the setup of a SonarQube environment using **Minikube, Kubernetes, Helm, and Terraform**. It provisions a local Kubernetes cluster, installs necessary tools, and deploys a SonarQube instance with PostgreSQL as the database. The setup script is designed to run in a Linux environment.

**Table of Contents**

1. Introduction

2. Architecture

3. Prerequisites

4. Setup and Installation

5. Usage

6. Configuration

7. Cleanup

## **Introduction**

SonarQube is an open-source platform for continuous inspection of code quality. This project uses Minikube to simulate a Kubernetes environment on a local machine and leverages Terraform for infrastructure as code, making the setup modular and easy to maintain.

The project includes:

A bash script (`setup.sh`) to automate the installation of Minikube, Kubectl, Helm, and Terraform.

A Terraform configuration (`main.tf`) for creating a SonarQube deployment in a Kubernetes cluster.

A YAML configuration file (`sonarqube-config.yaml`) for configuring SonarQube with PostgreSQL as the database.

## **Architecture**

![architecture drawio](https://github.com/user-attachments/assets/1c59700b-4eb9-4460-aec5-76be8bf00904)

## **Prerequisites**

Make sure your system meets the following requirements:

> Linux (Ubuntu or similar distribution)

> Bash shell

> Curl

> Sudo privileges

## **Setup and Installation**

To set up and install the required tools and deploy the SonarQube environment, follow these steps:

**1. Clone the repository:**

``git clone https://github.com/Dr3xel/sonarcube-mini-hw.git``

``cd sonarcube-mini-hw``

**2. Run the setup script:**
 
The setup.sh script will install Minikube, Kubectl, Helm, and Terraform if they are not already installed, and then use Terraform to deploy the SonarQube environment.

``chmod +x setup.sh``

``./setup.sh``

This script will:

Install Minikube, Kubectl, Helm, and Terraform.

Start a Minikube cluster with 2 CPUs and 4096 MB memory.

Enable the Ingress addon in Minikube.

Deploy SonarQube using Terraform and Helm.

Verify that all pods are running in the sonarqube namespace.

**3. Verify the setup:**

Once the setup completes, the script will display the status of the SonarQube environment. You can verify the Minikube status, Kubernetes pods, and Helm releases.

``minikube status``

``kubectl get pods -n sonarqube``

``helm list -n sonarqube``

## **Usage**

After the setup, you can access the SonarQube web UI by running the following command:

``kubectl port-forward sonarqube-sonarqube-0 9000:9000 -n sonarqube``

And then openning `127.0.0.1:9000` in your browser

## **Configuration**

The main configuration file for the SonarQube Helm chart is `sonarqube-config.yaml`. It contains the following key settings:

**PostgreSQL:** Enabled with default settings for the JDBC URL, username, and password.

**Persistence:** Configured for persistent storage with 10Gi of space.

**Resource Limits:** CPU and memory limits/requests are set for the SonarQube pods.

Feel free to modify these configurations to suit your needs.

## **Cleanup**

To delete the deployed SonarQube environment, you can run:

``terraform destroy --auto-approve``

This will tear down all Kubernetes resources managed by Terraform.

To stop and delete the Minikube cluster, run:

``minikube stop``

``minikube delete``


## **Architecture**

![architecture drawio](https://github.com/user-attachments/assets/1c59700b-4eb9-4460-aec5-76be8bf00904)
