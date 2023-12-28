resource "azurerm_resource_group" "azurecni" {
  name     = "azurecnirg"
  location = "canadacentral"
}

resource "azurerm_virtual_network" "azurecni" {
  name                = "azurecnirg-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.azurecni.location
  resource_group_name = azurerm_resource_group.azurecni.name
}

resource "azurerm_subnet" "azurecni" {
  name                 = "azurecnirg-subnet"
  resource_group_name  = azurerm_resource_group.azurecni.name
  virtual_network_name = azurerm_virtual_network.azurecni.name
  address_prefixes     = ["10.10.0.0/16"]

}

resource "azurerm_kubernetes_cluster" "azurecni" {
  name                = "azurecniaks"
  location            = azurerm_resource_group.azurecni.location
  resource_group_name = azurerm_resource_group.azurecni.name
  dns_prefix          = "azurecniaks"
  default_node_pool {
    name           = "default"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.azurecni.id
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }
}
