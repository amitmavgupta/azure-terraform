resource "azurerm_resource_group" "byopr" {
  name     = "byopr"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "byopr" {
  name                = "byopr-vnet"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.byopr.location
  resource_group_name = azurerm_resource_group.byopr.name
}
resource "azurerm_subnet" "byopr" {
  name                 = "byopr-subnet"
  resource_group_name  = azurerm_resource_group.byopr.name
  virtual_network_name = azurerm_virtual_network.byopr.name
  address_prefixes     = ["192.168.10.0/24"]
}
resource "azurerm_kubernetes_cluster" "byopr" {
  name                = "byopr"
  location            = azurerm_resource_group.byopr.location
  resource_group_name = azurerm_resource_group.byopr.name
  kubernetes_version  = 1.29
  dns_prefix          = "byopr"
  private_cluster_enabled  = true
  private_cluster_public_fqdn_enabled = true
  private_dns_zone_id = "System"
  default_node_pool {
    name           = "byopr"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.byopr.id
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    pod_cidr       = "10.10.0.0/22"
    service_cidr   = "10.20.0.0/24"
    dns_service_ip = "10.20.0.10"
    network_plugin = "none"
    load_balancer_sku = "standard"
  }
}
