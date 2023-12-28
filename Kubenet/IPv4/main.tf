resource "azurerm_resource_group" "kubenetipv4" {
  name     = "kubenetipv4"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "kubenetipv4" {
  name                = "kubenetipv4-vnet"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.kubenetipv4.location
  resource_group_name = azurerm_resource_group.kubenetipv4.name
}
resource "azurerm_subnet" "kubenetipv4" {
  name                 = "kubenetipv4-subnet"
  resource_group_name  = azurerm_resource_group.kubenetipv4.name
  virtual_network_name = azurerm_virtual_network.kubenetipv4.name
  address_prefixes     = ["192.168.10.0/24"]

}
resource "azurerm_kubernetes_cluster" "kubenetipv4" {
  name                = "kubenetipv4aks"
  location            = azurerm_resource_group.kubenetipv4.location
  resource_group_name = azurerm_resource_group.kubenetipv4.name
  dns_prefix          = "kubenetipv4aks"
  default_node_pool {
    name              = "kubenetipv4"
    node_count        = 2
    vm_size           = "Standard_DS2_v2"
    vnet_subnet_id    = azurerm_subnet.kubenetipv4.id
  }

  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin   = "kubenet"
    ip_versions      = ["IPv4"]
    pod_cidr         = "10.10.0.0/22"
    service_cidr     = "10.20.0.0/24"
    dns_service_ip   = "10.20.0.10"
  }
}