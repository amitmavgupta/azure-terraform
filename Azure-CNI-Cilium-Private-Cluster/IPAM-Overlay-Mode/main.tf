resource "azurerm_resource_group" "azpcolaypr" {
  name     = "azpcolaypr"
  location = "canadacentral"
}
resource "azurerm_kubernetes_cluster" "azpcolaypr" {
  name                                = "azpcolaypr"
  location                            = azurerm_resource_group.azpcolaypr.location
  resource_group_name                 = azurerm_resource_group.azpcolaypr.name
  kubernetes_version  = 1.29
  dns_prefix                          = "azpcolaypr"
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = true
  private_dns_zone_id                 = "System"
  default_node_pool {
    name           = "azpcolaypr"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    pod_cidr            = "10.10.0.0/22"
    service_cidr        = "10.20.0.0/24"
    dns_service_ip      = "10.20.0.10"
    network_policy      = "cilium"
    load_balancer_sku   = "standard"
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    ebpf_data_plane     = "cilium"
  }
}
