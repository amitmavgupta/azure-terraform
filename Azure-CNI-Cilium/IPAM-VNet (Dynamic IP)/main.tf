resource "azurerm_resource_group" "azpcdynamic" {
  name     = "azpcdynamic"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "azpcdynamic" {
  name                = "azpcdynamic-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.azpcdynamic.location
  resource_group_name = azurerm_resource_group.azpcdynamic.name
}
resource "azurerm_subnet" "azpcdynamicnodes" {
  name                 = "azpcdynamic-subnet-node"
  resource_group_name  = azurerm_resource_group.azpcdynamic.name
  virtual_network_name = azurerm_virtual_network.azpcdynamic.name
  address_prefixes     = ["10.240.0.0/16"]
}
resource "azurerm_subnet" "azpcdynamicpods" {
  name                 = "azpcdynamic-subnet-pods"
  resource_group_name  = azurerm_resource_group.azpcdynamic.name
  virtual_network_name = azurerm_virtual_network.azpcdynamic.name
  address_prefixes     = ["10.241.0.0/16"]
}
resource "azurerm_kubernetes_cluster" "azpcdynamic" {
  name                = "azpcdynamic"
  location            = azurerm_resource_group.azpcdynamic.location
  resource_group_name = azurerm_resource_group.azpcdynamic.name
  kubernetes_version  = 1.29
  dns_prefix          = "azpcdynamic"
  default_node_pool {
    name           = "azpcdynamic"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.azpcdynamicnodes.id
    pod_subnet_id  = azurerm_subnet.azpcdynamicpods.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin  = "azure"
    network_data_plane = "cilium"
  }
}