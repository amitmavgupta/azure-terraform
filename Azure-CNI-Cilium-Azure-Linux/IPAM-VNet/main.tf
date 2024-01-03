resource "azurerm_resource_group" "azpcdynamical" {
  name     = "azpcdynamical"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "azpcdynamical" {
  name                = "azpcdynamical-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.azpcdynamical.location
  resource_group_name = azurerm_resource_group.azpcdynamical.name
}
resource "azurerm_subnet" "azpcdynamicalnodes" {
  name                 = "azpcdynamical-subnet-node"
  resource_group_name  = azurerm_resource_group.azpcdynamical.name
  virtual_network_name = azurerm_virtual_network.azpcdynamical.name
  address_prefixes     = ["10.240.0.0/16"]
}
resource "azurerm_subnet" "azpcdynamicalpods" {
  name                 = "azpcdynamical-subnet-pods"
  resource_group_name  = azurerm_resource_group.azpcdynamical.name
  virtual_network_name = azurerm_virtual_network.azpcdynamical.name
  address_prefixes     = ["10.241.0.0/16"]
}
resource "azurerm_kubernetes_cluster" "azpcdynamical" {
  name                = "azpcdynamical"
  location            = azurerm_resource_group.azpcdynamical.location
  resource_group_name = azurerm_resource_group.azpcdynamical.name
  dns_prefix          = "azpcdynamical"
  default_node_pool {
    name           = "azpcdynamical"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    os_sku         = "AzureLinux"
    vnet_subnet_id = azurerm_subnet.azpcdynamicalnodes.id
    pod_subnet_id  = azurerm_subnet.azpcdynamicalpods.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin  = "azure"
    ebpf_data_plane = "cilium"
  }
}