resource "azurerm_resource_group" "azcnioverlay" {
  name     = "azcnioverlay"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "azcnioverlay" {
  name                = "azcnioverlay-vnet"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.azcnioverlay.location
  resource_group_name = azurerm_resource_group.azcnioverlay.name
}
resource "azurerm_subnet" "azcnioverlay" {
  name                 = "azcnioverlay-subnet"
  resource_group_name  = azurerm_resource_group.azcnioverlay.name
  virtual_network_name = azurerm_virtual_network.azcnioverlay.name
  address_prefixes     = ["192.168.10.0/24"]
}
resource "azurerm_kubernetes_cluster" "azcnioverlay" {
  name                = "azcnioverlayaks"
  location            = azurerm_resource_group.azcnioverlay.location
  resource_group_name = azurerm_resource_group.azcnioverlay.name
  dns_prefix          = "azcnioverlayaks"
  default_node_pool {
    name              = "azcnioverlay"
    node_count        = 2
    vm_size           = "Standard_DS2_v2"
    vnet_subnet_id    = azurerm_subnet.azcnioverlay.id
  }
  
  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin	    = "azure"
    network_plugin_mode	= "overlay"
    pod_cidr            = "10.10.0.0/16"
  }
}