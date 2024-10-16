resource "azurerm_resource_group" "azurevm" {
  name     = "azurevm"
  location = "canadacentral"
}

# Create virtual network
resource "azurerm_virtual_network" "azure_vnet" {
  name                = "azure-vnet"
  address_space       = ["10.40.0.0/24"]
  location            = azurerm_resource_group.azurevm.location
  resource_group_name = azurerm_resource_group.azurevm.name
}

# Create subnet
resource "azurerm_subnet" "azure_subnet" {
  name                 = "azure-subnet"
  resource_group_name  = azurerm_resource_group.azurevm.name
  virtual_network_name = azurerm_virtual_network.azure_vnet.name
  address_prefixes     = ["10.40.0.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "azure_public_ip" {
  name                = "azure-public-ip"
  location            = azurerm_resource_group.azurevm.location
  resource_group_name = azurerm_resource_group.azurevm.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "azure_nsg" {
  name                = "azure-nsg"
  location            = azurerm_resource_group.azurevm.location
  resource_group_name = azurerm_resource_group.azurevm.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "azure_nic" {
  name                = "azure-nic"
  location            = azurerm_resource_group.azurevm.location
  resource_group_name = azurerm_resource_group.azurevm.name

  ip_configuration {
    name                          = "azure-ip-configuration"
    subnet_id                     = azurerm_subnet.azure_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azure_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg-nic-association" {
  network_interface_id      = azurerm_network_interface.azure_nic.id
  network_security_group_id = azurerm_network_security_group.azure_nsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "azure_storage_account" {
  name                     = "azurestorage16102024"
  location                 = azurerm_resource_group.azurevm.location
  resource_group_name      = azurerm_resource_group.azurevm.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "azure_vm" {
  name                  = "azure-vm"
  location              = azurerm_resource_group.azurevm.location
  resource_group_name   = azurerm_resource_group.azurevm.name
  network_interface_ids = [azurerm_network_interface.azure_nic.id]
  size                  = "Standard_B2s"

  os_disk {
    name                 = "azure-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  computer_name                   = "azurevm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.azure_storage_account.primary_blob_endpoint
  }
}
