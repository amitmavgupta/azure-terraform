resource "azurerm_resource_group" "azpcdynal" {
  name     = "azpcdynal"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "azpcdynal" {
  name                = "azpcdynal-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.azpcdynal.location
  resource_group_name = azurerm_resource_group.azpcdynal.name
}
resource "azurerm_subnet" "azpcdynalnodes" {
  name                 = "azpcdynal-subnet-node"
  resource_group_name  = azurerm_resource_group.azpcdynal.name
  virtual_network_name = azurerm_virtual_network.azpcdynal.name
  address_prefixes     = ["10.240.0.0/16"]
}
resource "azurerm_subnet" "azpcdynalpods" {
  name                 = "azpcdynal-subnet-pods"
  resource_group_name  = azurerm_resource_group.azpcdynal.name
  virtual_network_name = azurerm_virtual_network.azpcdynal.name
  address_prefixes     = ["10.241.0.0/16"]
}
resource "azurerm_kubernetes_cluster" "azpcdynal" {
  name                = "azpcdynal"
  location            = azurerm_resource_group.azpcdynal.location
  resource_group_name = azurerm_resource_group.azpcdynal.name
  kubernetes_version  = 1.29
  dns_prefix          = "azpcdynal"
  default_node_pool {
    name           = "azpcdynal"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    os_sku         = "AzureLinux"
    vnet_subnet_id = azurerm_subnet.azpcdynalnodes.id
    pod_subnet_id  = azurerm_subnet.azpcdynalpods.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin  = "azure"
    network_data_plane = "cilium"
  }
}
