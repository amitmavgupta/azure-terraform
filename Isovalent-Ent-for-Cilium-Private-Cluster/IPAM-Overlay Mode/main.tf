resource "azurerm_resource_group" "prie4colay" {
  name     = "prie4colay"
  location = "canadacentral"
}
resource "azurerm_kubernetes_cluster" "prie4colay" {
  name                = "prie4colay"
  location            = azurerm_resource_group.prie4colay.location
  resource_group_name = azurerm_resource_group.prie4colay.name
  dns_prefix          = "prie4colay"
  private_cluster_enabled  = true
  private_cluster_public_fqdn_enabled = true
  private_dns_zone_id = "System"
  default_node_pool {
    name       = "prie4colay"
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
    ebpf_data_plane     = "cilium"
  }
}

resource "azurerm_kubernetes_cluster_extension" "cilium" {
  name           = "cilium"
  cluster_id     = azurerm_kubernetes_cluster.prie4colay.id
  extension_type = "Isovalent.CiliumEnterprise.One"
  plan {
    name      = var.plan_name
    product   = var.plan_product
    publisher = var.plan_publisher
  }
}