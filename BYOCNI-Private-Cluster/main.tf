resource "azurerm_resource_group" "byopraks" {
  name     = "byopraks"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "byopraks" {
  name                = "byopraks-vnet"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.byopraks.location
  resource_group_name = azurerm_resource_group.byopraks.name
}
resource "azurerm_subnet" "byopraks" {
  name                 = "byopraks-subnet"
  resource_group_name  = azurerm_resource_group.byopraks.name
  virtual_network_name = azurerm_virtual_network.byopraks.name
  address_prefixes     = ["192.168.10.0/24"]
}
resource "azurerm_kubernetes_cluster" "byopraks" {
  name                = "byopraks"
  location            = azurerm_resource_group.byopraks.location
  resource_group_name = azurerm_resource_group.byopraks.name
  dns_prefix          = "byopraks"
  private_cluster_enabled  = true
  private_cluster_public_fqdn_enabled = true
  private_dns_zone_id = "None"
  default_node_pool {
    name           = "byopraks"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.byopraks.id
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    pod_cidr       = "10.10.0.0/22"
    service_cidr   = "10.20.0.0/24"
    dns_service_ip = "10.20.0.10"
    network_plugin = "none"
  }
}