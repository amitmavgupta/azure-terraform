resource "azurerm_resource_group" "azcniolayds" {
  name     = "azcniolayds"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "azcniolayipv4" {
  name                  = "azcniolayipv4-vnet"
  address_space         = ["192.168.10.0/24"]
  location              = azurerm_resource_group.azcniolayds.location
  resource_group_name   = azurerm_resource_group.azcniolayds.name
}
resource "azurerm_subnet" "azcniolayipv4subnet" {
  name                  = "azcniolayipv4-subnet"
  virtual_network_name  = azurerm_virtual_network.azcniolayipv4.name
  address_prefixes      = ["192.168.10.0/24"]
  resource_group_name   = azurerm_resource_group.azcniolayds.name
}
resource "azurerm_virtual_network" "azcniolayipv6" {
  name                  = "azcniolayipv6-vnet"
  address_space         = ["1900::/64"]
  location              = azurerm_resource_group.azcniolayds.location
  resource_group_name   = azurerm_resource_group.azcniolayds.name
}
resource "azurerm_subnet" "azcniolayipv6subnet" {
  name                 = "azcniolayipv6-subnet"
  virtual_network_name = azurerm_virtual_network.azcniolayipv6.name
  address_prefixes     = ["1900::/64"]
  resource_group_name  = azurerm_resource_group.azcniolayds.name
}
resource "azurerm_kubernetes_cluster" "azcniolayds" {
  name                = "azcniolaydsaks"
  location            = azurerm_resource_group.azcniolayds.location
  resource_group_name = azurerm_resource_group.azcniolayds.name
  dns_prefix          = "azcniolaydsaks"
  default_node_pool {
    name             = "azcniolayds"
    node_count       = 2
    vm_size          = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "cilium"
    ip_versions    = ["IPv4", "IPv6"]
    network_plugin_mode = "overlay"
    pod_cidrs      = ["10.10.0.0/22", "2001::/64"]
    service_cidrs  = ["10.20.0.0/24", "2001:1::/108"]
    dns_service_ip = "10.20.0.10"
  }
}