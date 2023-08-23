resource "azurerm_resource_group" "azurecilium" {
  name     = "azurecilium"
  location = "canadacentral"
}

resource "azurerm_virtual_network" "azurecilium" {
  name                = "azurecilium-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.azurecilium.location
  resource_group_name = azurerm_resource_group.azurecilium.name
}

resource "azurerm_subnet" "azureciliumnodes" {
  name                 = "azurecilium-subnet-node"
  resource_group_name  = azurerm_resource_group.azurecilium.name
  virtual_network_name = azurerm_virtual_network.azurecilium.name
  address_prefixes     = ["10.240.0.0/16"]

}

resource "azurerm_subnet" "azureciliumpods" {
  name                 = "azurecilium-subnet-pods"
  resource_group_name  = azurerm_resource_group.azurecilium.name
  virtual_network_name = azurerm_virtual_network.azurecilium.name
  address_prefixes     = ["10.241.0.0/16"]

}

resource "azurerm_kubernetes_cluster" "azurecilium" {
  name                = "azurecilium"
  location            = azurerm_resource_group.azurecilium.location
  resource_group_name = azurerm_resource_group.azurecilium.name
  dns_prefix          = "azurecilium"
  default_node_pool {
    name           = "azurecilium"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.azureciliumnodes.id
    pod_subnet_id  = azurerm_subnet.azureciliumpods.id

  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin  = "azure"
    ebpf_data_plane = "cilium"
  }
}