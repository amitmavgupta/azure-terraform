resource "azurerm_resource_group" "kubenet" {
  name     = "kubenet"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "kubenet" {
  name                = "kubenet-vnet"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.kubenet.location
  resource_group_name = azurerm_resource_group.kubenet.name
}
resource "azurerm_subnet" "kubenet" {
  name                 = "kubenet-subnet"
  resource_group_name  = azurerm_resource_group.kubenet.name
  virtual_network_name = azurerm_virtual_network.kubenet.name
  address_prefixes     = ["192.168.10.0/24"]
}
resource "azurerm_kubernetes_cluster" "kubenet" {
  name                = "kubenetaks"
  location            = azurerm_resource_group.kubenet.location
  resource_group_name = azurerm_resource_group.kubenet.name
  kubernetes_version  = 1.29
  dns_prefix          = "kubenetaks"
  default_node_pool {
    name              = "kubenet"
    node_count        = 2
    vm_size           = "Standard_DS2_v2"
    vnet_subnet_id    = azurerm_subnet.kubenet.id
  }

  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin   = "kubenet"
    network_policy   = "calico"
    ip_versions      = ["IPv4"]
    pod_cidr         = "10.10.0.0/22"
    service_cidr     = "10.20.0.0/24"
    dns_service_ip   = "10.20.0.10"
  }
}
