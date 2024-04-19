resource "azurerm_resource_group" "byocnial" {
  name     = "byocnial"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "byocnial" {
  name                = "byocnial-vnet"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.byocnial.location
  resource_group_name = azurerm_resource_group.byocnial.name
}
resource "azurerm_subnet" "byocnial" {
  name                 = "byocnial-subnet"
  resource_group_name  = azurerm_resource_group.byocnial.name
  virtual_network_name = azurerm_virtual_network.byocnial.name
  address_prefixes     = ["192.168.10.0/24"]
}
resource "azurerm_kubernetes_cluster" "byocnial" {
  name                = "byocnialaks"
  location            = azurerm_resource_group.byocnial.location
  resource_group_name = azurerm_resource_group.byocnial.name
  kubernetes_version  = 1.29
  dns_prefix          = "byocnialaks"
  default_node_pool {
    name           = "byocnial"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    os_sku         = "AzureLinux"
    vnet_subnet_id = azurerm_subnet.byocnial.id
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
