resource "azurerm_resource_group" "byocnidsal" {
  name     = "byocnidsal"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "byocnidsal" {
  name                = "byocnidsal-vnet"
  address_space       = ["192.168.10.0/24", "1900::/64"]
  location            = azurerm_resource_group.byocnidsal.location
  resource_group_name = azurerm_resource_group.byocnidsal.name
}
resource "azurerm_subnet" "byocnidsal" {
  name                 = "byocnidsal-subnet"
  virtual_network_name = azurerm_virtual_network.byocnidsal.name
  address_prefixes     = ["192.168.10.0/24", "1900::/64"]
  resource_group_name  = azurerm_resource_group.byocnidsal.name
}
resource "azurerm_kubernetes_cluster" "byocnidsal" {
  name                = "byocnidsalaks"
  location            = azurerm_resource_group.byocnidsal.location
  resource_group_name = azurerm_resource_group.byocnidsal.name
  kubernetes_version  = 1.29
  dns_prefix          = "byocnidsalaks"
  default_node_pool {
    name           = "byocnidsal"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    os_sku         = "AzureLinux"
    vnet_subnet_id = azurerm_subnet.byocnidsal.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "none"
    ip_versions    = ["IPv4", "IPv6"]
    pod_cidrs      = ["10.10.0.0/22", "2001::/64"]
    service_cidrs  = ["10.20.0.0/24", "2001:1::/108"]
    dns_service_ip = "10.20.0.10"
  }
}
