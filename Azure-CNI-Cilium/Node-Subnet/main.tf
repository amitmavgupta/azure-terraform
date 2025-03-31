resource "azurerm_resource_group" "azpcoverlay" {
  name     = "azpcoverlay"
  location = "canadacentral"
}
resource "azurerm_kubernetes_cluster" "azpcoverlay" {
  name                = "azpcoverlay"
  location            = azurerm_resource_group.azpcoverlay.location
  resource_group_name = azurerm_resource_group.azpcoverlay.name
  kubernetes_version  = 1.31
  dns_prefix          = "azpcoverlay"
  default_node_pool {
    name       = "azpcoverlay"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    ebpf_data_plane     = "cilium"
  }
}