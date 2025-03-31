resource "azurerm_resource_group" "azpcnodesubnet" {
  name     = "azpcnodesubnet"
  location = "canadacentral"
}
resource "azurerm_kubernetes_cluster" "azpcnodesubnet" {
  name                = "azpcnodesubnet"
  location            = azurerm_resource_group.azpcnodesubnet.location
  resource_group_name = azurerm_resource_group.azpcnodesubnet.name
  kubernetes_version  = 1.31
  dns_prefix          = "azpcnodesubnet"
  default_node_pool {
    name       = "azpcnodesubnet"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    pod_cidr            = "10.10.0.0/22"
    service_cidr        = "10.20.0.0/24"
    dns_service_ip      = "10.20.0.10"
    network_plugin      = "azure"
    network_data_plane  = "cilium"
  }
}