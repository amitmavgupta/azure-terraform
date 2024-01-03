resource "azurerm_resource_group" "azpcoverlay" {
  name     = "azpcoverlay"
  location = "canadacentral"
}
resource "azurerm_kubernetes_cluster" "azpcoverlay" {
  name                = "azpcoverlay"
  location            = azurerm_resource_group.azpcoverlay.location
  resource_group_name = azurerm_resource_group.azpcoverlay.name
  dns_prefix          = "azpcoverlay"
  default_node_pool {
    name       = "azpcoverlay"
    node_count = 2
    vm_size    = "Standard_D2_v2"
    type       = "VirtualMachineScaleSets"
    zones      = ["1", "2"]
    enable_auto_scaling = true
    min_count  = 2
    max_count  = 4
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