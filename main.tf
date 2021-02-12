resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.location
}
resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}
resource "azurerm_log_analytics_workspace" "test" {
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.log_analytics_workspace_location
  resource_group_name = azurerm_resource_group.k8s.name
  sku                 = var.log_analytics_workspace_sku
}
resource "azurerm_log_analytics_solution" "test" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.test.location
  resource_group_name   = azurerm_resource_group.k8s.name
  workspace_resource_id = azurerm_log_analytics_workspace.test.id
  workspace_name        = azurerm_log_analytics_workspace.test.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  default_node_pool {
    name       = "agentpool"
    node_count = var.agent_count
    vm_size    = "Standard_DS1_v2"
  }
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
    }
  }
  tags = {
    Environment = "Development"
  }
}

variable "client_id" {}
variable "client_secret" {}

variable "agent_count" {
  default = 1
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "k8stest"
}

variable "cluster_name" {
  default = "k8stest"
}

variable "resource_group_name" {
  default = "azure-k8stest"
}

variable "location" {
  default = "East US"
}

variable "log_analytics_workspace_name" {
  default = "testLogAnalyticsWorkspaceName"
}

variable "log_analytics_workspace_location" {
  default = "eastus"
}

variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}
output "client_key" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_key
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate
}

output "cluster_username" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.username
}

output "cluster_password" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.password
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
}

output "host" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.host
}


