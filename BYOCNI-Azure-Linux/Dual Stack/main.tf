resource "azurerm_resource_group" "byocnidsal" {
  name     = "byocnidsal"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "byocnidsal" {
  name                = "byocnidsal-vnet"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.byocnidsal.location
  resource_group_name = azurerm_resource_group.byocnidsal.name
}
resource "azurerm_subnet" "byocnidsal" {
  name                 = "byocnidsal-subnet"
  resource_group_name  = azurerm_resource_group.byocnidsal.name
  virtual_network_name = azurerm_virtual_network.byocnidsal.name
  address_prefixes     = ["192.168.10.0/24"]
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
    pod_cidr       = "10.10.0.0/22"
    service_cidr   = "10.20.0.0/24"
    dns_service_ip = "10.20.0.10"
    network_plugin = "none"
  }
}
