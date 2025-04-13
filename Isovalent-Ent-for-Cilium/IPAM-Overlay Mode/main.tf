resource "azurerm_resource_group" "ie4coverlay" {
  name     = "ie4coverlay"
  location = "canadacentral"
}
resource "azurerm_kubernetes_cluster" "ie4coverlay" {
  name                = "ie4coverlay"
  location            = azurerm_resource_group.ie4coverlay.location
  resource_group_name = azurerm_resource_group.ie4coverlay.name
  kubernetes_version  = 1.29
  dns_prefix          = "ie4coverlay"
  default_node_pool {
    name       = "ie4coverlay"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    pod_cidr            = "10.10.0.0/22"
    service_cidr        = "10.20.0.0/24"
    dns_service_ip      = "10.20.0.10"
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
<<<<<<< HEAD
    network_data_plane = "cilium"
=======
    ebpf_data_plane = "cilium"
>>>>>>> 8b45fb5 (Rolling back changes from network_data_plane.)
  }
}

resource "azurerm_kubernetes_cluster_extension" "cilium" {
  name           = "cilium"
  cluster_id     = azurerm_kubernetes_cluster.ie4coverlay.id
  extension_type = "Isovalent.CiliumEnterprise.One"
  plan {
    name      = var.plan_name
    product   = var.plan_product
    publisher = var.plan_publisher
  }
}
