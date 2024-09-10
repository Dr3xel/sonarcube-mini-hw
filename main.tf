provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Define the namespace for SonarQube
resource "kubernetes_namespace" "sonarqube" {
  metadata {
    name = "sonarqube"
  }
}

# Helm release for SonarQube, using external PostgreSQL
resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  repository = "https://SonarSource.github.io/helm-chart-sonarqube"
  chart      = "sonarqube"
  namespace  = kubernetes_namespace.sonarqube.metadata[0].name

  values = [
    "${file("${path.module}/sonarqube-config.yaml")}"
  ]
}