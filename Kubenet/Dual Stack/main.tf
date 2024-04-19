resource "azurerm_resource_group" "kubenetds" {
  name     = "kubenetds"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "kubenetipv4" {
  name                = "kubenetipv4-vnet"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.kubenetds.location
  resource_group_name = azurerm_resource_group.kubenetds.name
}
resource "azurerm_subnet" "kubenetipv4subnet" {
  name                 = "kubenetipv4-subnet"
  virtual_network_name = azurerm_virtual_network.kubenetipv4.name
  address_prefixes     = ["192.168.10.0/24"]
  resource_group_name  = azurerm_resource_group.kubenetds.name
}
resource "azurerm_virtual_network" "kubenetipv6" {
  name                = "kubenetipv6-vnet"
  address_space       = ["1900::/64"]
  location            = azurerm_resource_group.kubenetds.location
  resource_group_name = azurerm_resource_group.kubenetds.name
}
resource "azurerm_subnet" "kubenetipv6subnet" {
  name                 = "kubenetipv6-subnet"
  virtual_network_name = azurerm_virtual_network.kubenetipv6.name
  address_prefixes     = ["1900::/64"]
  resource_group_name  = azurerm_resource_group.kubenetds.name
}
resource "azurerm_kubernetes_cluster" "kubenetds" {
  name                = "kubenetdsaks"
  location            = azurerm_resource_group.kubenetds.location
  resource_group_name = azurerm_resource_group.kubenetds.name
  kubernetes_version  = 1.29
  dns_prefix          = "kubenetdsaks"
  default_node_pool {
    name       = "kubenetds"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }
  
  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
    ip_versions    = ["IPv4", "IPv6"]
    pod_cidrs      = ["10.10.0.0/22", "2001::/64"]
    service_cidrs  = ["10.20.0.0/24", "2001:1::/108"]
    dns_service_ip = "10.20.0.10"
  }
}
