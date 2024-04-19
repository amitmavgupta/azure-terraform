resource "azurerm_resource_group" "azpcoverlaypr" {
  name     = "azpcoverlaypr"
  location = "canadacentral"
}
resource "azurerm_kubernetes_cluster" "azpcoverlaypr" {
  name                                = "azpcoverlaypr"
  location                            = azurerm_resource_group.azpcoverlaypr.location
  resource_group_name                 = azurerm_resource_group.azpcoverlaypr.name
  kubernetes_version  = 1.29
  dns_prefix                          = "azpcoverlaypr"
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = true
  private_dns_zone_id                 = "System"
  default_node_pool {
    name           = "azpcoverlaypr"
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
