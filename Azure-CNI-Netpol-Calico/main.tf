resource "azurerm_resource_group" "azcni" {
  name     = "azcnirg"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "azcni" {
  name                = "azcni-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.azcni.location
  resource_group_name = azurerm_resource_group.azcni.name
}
resource "azurerm_subnet" "azcni" {
  name                 = "azcni-subnet"
  resource_group_name  = azurerm_resource_group.azcni.name
  virtual_network_name = azurerm_virtual_network.azcni.name
  address_prefixes     = ["10.10.0.0/16"]
}
resource "azurerm_kubernetes_cluster" "azcni" {
  name                = "azcni"
  location            = azurerm_resource_group.azcni.location
  resource_group_name = azurerm_resource_group.azcni.name
  kubernetes_version  = 1.29
  dns_prefix          = "azcni"
  default_node_pool {
    name           = "azcni"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.azcni.id
  }

  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }
}
