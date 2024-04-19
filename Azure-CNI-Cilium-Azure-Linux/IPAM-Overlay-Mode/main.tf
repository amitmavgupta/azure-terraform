resource "azurerm_resource_group" "azpcoverlayal" {
  name     = "azpcoverlayal"
  location = "canadacentral"
}
resource "azurerm_kubernetes_cluster" "azpcoverlayal" {
  name                = "azpcoverlayal"
  location            = azurerm_resource_group.azpcoverlayal.location
  resource_group_name = azurerm_resource_group.azpcoverlayal.name
  kubernetes_version  = 1.29
  dns_prefix          = "azpcoverlayal"
  default_node_pool {
    name       = "azpcoverlayal"
    node_count = 2
    os_sku     = "AzureLinux"
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
    network_plugin_mode = "overlay"
    ebpf_data_plane     = "cilium"
  }
}
