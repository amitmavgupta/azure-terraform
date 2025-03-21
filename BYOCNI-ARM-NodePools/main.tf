resource "azurerm_resource_group" "byocni" {
  name     = "byocni"
  location = "canadacentral"
  tags = {
    Environment        = "azure-demos"
    owner              = "Amit Gupta"
    expiry             = "2123-04-09 00:19:27.909960"
    resourceNameSuffix = "byocni"
  }
}
resource "azurerm_virtual_network" "byocni" {
  name                = "byocni-vnet"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.byocni.location
  resource_group_name = azurerm_resource_group.byocni.name
}
resource "azurerm_subnet" "byocni" {
  name                 = "byocni-subnet"
  resource_group_name  = azurerm_resource_group.byocni.name
  virtual_network_name = azurerm_virtual_network.byocni.name
  address_prefixes     = ["192.168.10.0/24"]
}
resource "azurerm_kubernetes_cluster" "byocni" {
  name                = "byocni"
  location            = azurerm_resource_group.byocni.location
  resource_group_name = azurerm_resource_group.byocni.name
  kubernetes_version  = 1.29
  dns_prefix          = "byocni"
  default_node_pool {
    name           = "byocni"
    node_count     = 2
    vm_size        = "Standard_D2ps_v5"
    vnet_subnet_id = azurerm_subnet.byocni.id
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
