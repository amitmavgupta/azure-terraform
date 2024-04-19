resource "azurerm_resource_group" "ie4cdynamic" {
  name     = "ie4cdynamic"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "ie4cdynamic" {
  name                = "ie4cdynamic-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.ie4cdynamic.location
  resource_group_name = azurerm_resource_group.ie4cdynamic.name
}
resource "azurerm_subnet" "ie4cdynamicnodes" {
  name                 = "ie4cdynamic-subnet-node"
  resource_group_name  = azurerm_resource_group.ie4cdynamic.name
  virtual_network_name = azurerm_virtual_network.ie4cdynamic.name
  address_prefixes     = ["10.240.0.0/16"]
}
resource "azurerm_subnet" "ie4cdynamicpods" {
  name                 = "ie4cdynamic-subnet-pods"
  resource_group_name  = azurerm_resource_group.ie4cdynamic.name
  virtual_network_name = azurerm_virtual_network.ie4cdynamic.name
  address_prefixes     = ["10.241.0.0/16"]
}
resource "azurerm_kubernetes_cluster" "ie4cdynamic" {
  name                = "ie4cdynamic"
  location            = azurerm_resource_group.ie4cdynamic.location
  resource_group_name = azurerm_resource_group.ie4cdynamic.name
  kubernetes_version  = 1.29
  dns_prefix          = "ie4cdynamic"
  default_node_pool {
    name           = "ie4cdynamic"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.azpcdynamicnodes.id
    pod_subnet_id  = azurerm_subnet.azpcdynamicpods.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin  = "azure"
    ebpf_data_plane = "cilium"
  }
}

resource "azurerm_kubernetes_cluster_extension" "cilium" {
  name           = "cilium"
  cluster_id     = azurerm_kubernetes_cluster.ie4cdynamic.id
  extension_type = "Isovalent.CiliumEnterprise.One"
  plan {
    name      = var.plan_name
    product   = var.plan_product
    publisher = var.plan_publisher
  }
}
