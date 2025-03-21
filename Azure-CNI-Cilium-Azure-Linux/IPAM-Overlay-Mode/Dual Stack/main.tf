resource "azurerm_resource_group" "azpcoldsal" {
  name     = "azpcoldsal"
  location = "canadacentral"
}
resource "azurerm_kubernetes_cluster" "azpcoldsal" {
  name                = "azpcoldsal"
  location            = azurerm_resource_group.azpcoldsal.location
  resource_group_name = azurerm_resource_group.azpcoldsal.name
  kubernetes_version  = 1.29
  dns_prefix          = "azpcoldsal"
  default_node_pool {
    name       = "azpcoldsal"
    node_count = 2
    os_sku     = "AzureLinux"
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
    ip_versions         = ["IPv4", "IPv6"]
    pod_cidrs           = ["10.10.0.0/22", "2001::/64"]
    service_cidrs       = ["10.20.0.0/24", "2001:1::/108"]
    dns_service_ip      = "10.20.0.10"
  }
}