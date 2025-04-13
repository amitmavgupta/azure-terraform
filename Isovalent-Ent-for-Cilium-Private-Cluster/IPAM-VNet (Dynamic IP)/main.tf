resource "azurerm_resource_group" "prie4cdyna" {
  name     = "prie4cdyna"
  location = "canadacentral"
}
resource "azurerm_virtual_network" "prie4cdyna" {
  name                = "prie4cdyna-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.prie4cdyna.location
  resource_group_name = azurerm_resource_group.prie4cdyna.name
}
resource "azurerm_subnet" "prie4cdynanodes" {
  name                 = "prie4cdyna-subnet-node"
  resource_group_name  = azurerm_resource_group.prie4cdyna.name
  virtual_network_name = azurerm_virtual_network.prie4cdyna.name
  address_prefixes     = ["10.240.0.0/16"]
}
resource "azurerm_subnet" "prie4cdynapods" {
  name                 = "prie4cdyna-subnet-pods"
  resource_group_name  = azurerm_resource_group.prie4cdyna.name
  virtual_network_name = azurerm_virtual_network.prie4cdyna.name
  address_prefixes     = ["10.241.0.0/16"]
}
resource "azurerm_kubernetes_cluster" "prie4cdyna" {
  name                = "prie4cdyna"
  location            = azurerm_resource_group.prie4cdyna.location
  resource_group_name = azurerm_resource_group.prie4cdyna.name
  kubernetes_version  = 1.29
  dns_prefix          = "prie4cdyna"
  private_cluster_enabled  = true
  private_cluster_public_fqdn_enabled = true
  private_dns_zone_id = "System"
  default_node_pool {
    name           = "prie4cdyna"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.prie4cdynanodes.id
    pod_subnet_id  = azurerm_subnet.prie4cdynapods.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin  = "azure"
    ebpf_data_plane = "cilium"
    network_policy = "cilium"
  }
}

resource "azurerm_kubernetes_cluster_extension" "cilium" {
  name           = "cilium"
  cluster_id     = azurerm_kubernetes_cluster.prie4cdyna.id
  extension_type = "Isovalent.CiliumEnterprise.One"
  plan {
    name      = var.plan_name
    product   = var.plan_product
    publisher = var.plan_publisher
  }
}
