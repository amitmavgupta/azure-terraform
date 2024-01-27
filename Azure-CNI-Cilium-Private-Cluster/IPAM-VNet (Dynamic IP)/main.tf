resource "azurerm_resource_group" "azpcdynapr" {
  name     = "azpcdynapr"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "azpcdynapr" {
  name                = "azpcdynapr-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.azpcdynapr.location
  resource_group_name = azurerm_resource_group.azpcdynapr.name
}
resource "azurerm_subnet" "azpcdynaprnodes" {
  name                 = "azpcdynamicpr-subnet-node"
  resource_group_name  = azurerm_resource_group.azpcdynapr.name
  virtual_network_name = azurerm_virtual_network.azpcdynapr.name
  address_prefixes     = ["10.240.0.0/16"]
}
resource "azurerm_subnet" "azpcdynaprpods" {
  name                 = "azpcdynamicpr-subnet-pods"
  resource_group_name  = azurerm_resource_group.azpcdynapr.name
  virtual_network_name = azurerm_virtual_network.azpcdynapr.name
  address_prefixes     = ["10.241.0.0/16"]
}
resource "azurerm_kubernetes_cluster" "azpcdynapr" {
  name                = "azpcdynapr"
  location            = azurerm_resource_group.azpcdynapr.location
  resource_group_name = azurerm_resource_group.azpcdynapr.name
  dns_prefix          = "azpcdynapr"
  private_cluster_enabled  = true
  private_cluster_public_fqdn_enabled = true
  private_dns_zone_id      = "None"
  default_node_pool {
    name           = "azpcdynapr"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.azpcdynaprnodes.id
    pod_subnet_id  = azurerm_subnet.azpcdynaprpods.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin  = "azure"
    ebpf_data_plane = "cilium"
  }
}
