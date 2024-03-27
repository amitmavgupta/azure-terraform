resource "azurerm_resource_group" "byocnids" {
  name     = "byocnids"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "byocniipv4" {
  name                = "byocniipv4-vnet"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.byocnids.location
  resource_group_name = azurerm_resource_group.byocnids.name
}
resource "azurerm_subnet" "byocniipv4subnet" {
  name                 = "byocniipv4-subnet"
  virtual_network_name = azurerm_virtual_network.byocniipv4.name
  address_prefixes     = ["192.168.10.0/24"]
  resource_group_name  = azurerm_resource_group.byocnids.name
}
resource "azurerm_virtual_network" "byocniipv6" {
  name                = "byocniipv6-vnet"
  address_space       = ["1900::/64"]
  location            = azurerm_resource_group.byocnids.location
  resource_group_name = azurerm_resource_group.byocnids.name
}
resource "azurerm_subnet" "byocniipv6subnet" {
  name                 = "byocniipv6-subnet"
  virtual_network_name = azurerm_virtual_network.byocniipv6.name
  address_prefixes     = ["1900::/64"]
  resource_group_name  = azurerm_resource_group.byocnids.name
}
resource "azurerm_kubernetes_cluster" "byocnids" {
  name                = "byocnidsaks"
  location            = azurerm_resource_group.byocnids.location
  resource_group_name = azurerm_resource_group.byocnids.name
  dns_prefix          = "byocnidsaks"
  default_node_pool {
    name       = "byocnids"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "none"
    ip_versions    = ["IPv4", "IPv6"]
    pod_cidrs      = ["10.10.0.0/22", "2001::/64"]
    service_cidrs  = ["10.20.0.0/24", "2001:1::/108"]
    dns_service_ip = "10.20.0.10"
  }
}