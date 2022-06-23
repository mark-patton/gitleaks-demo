resource "azurerm_resource_group" "mgmt_rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "mgmt_vnet" {
  name                = "mgmt_core_vnet"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.mgmt_rg.location
  resource_group_name = azurerm_resource_group.mgmt_rg.name
  depends_on          = [azurerm_resource_group.mgmt_rg]
}

resource "azurerm_subnet" "azure_bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.mgmt_rg.name
  virtual_network_name = azurerm_virtual_network.mgmt_vnet.name
  address_prefix       = "192.168.0.224/27"
  depends_on           = [azurerm_virtual_network.mgmt_vnet]
}

resource "azurerm_public_ip" "azure_bastion_ip" {
  name                = "azure_bastion_ip"
  location            = azurerm_resource_group.mgmt_rg.location
  resource_group_name = azurerm_resource_group.mgmt_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on          = [azurerm_resource_group.mgmt_rg]
}

resource "azurerm_bastion_host" "azure_bastion_host" {
  name                = "azure_bastion_host"
  location            = azurerm_resource_group.mgmt_rg.location
  resource_group_name = azurerm_resource_group.mgmt_rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.azure_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.azure_bastion_ip.id
  }

  depends_on = [azurerm_subnet.azure_bastion_subnet, azurerm_public_ip.azure_bastion_ip]
}