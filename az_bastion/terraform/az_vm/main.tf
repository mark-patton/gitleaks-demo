resource "azurerm_resource_group" "vm_rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_subnet" "jumpbox_vnet" {
  name                 = "jumpbox_vnet"
  resource_group_name  = var.subnet_rg
  virtual_network_name = "mgmt_core_vnet"
  address_prefix       = "192.168.1.0/24"
}

resource "azurerm_network_interface" "jumpbox_vm_nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = var.nic_name
    subnet_id                     = azurerm_subnet.jumpbox_vnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [azurerm_subnet.jumpbox_vnet]
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  name                = var.windows_vm_name
  resource_group_name = azurerm_resource_group.vm_rg.name
  location            = azurerm_resource_group.vm_rg.location
  size                = var.windows_vm_size
  admin_username      = "adminuser"     // demo inclusion only
  admin_password      = "P@$$w0rd1234!" // demo inclusion only
  network_interface_ids = [
    azurerm_network_interface.jumpbox_vm_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.windows_vm_details["publisher"]
    offer     = var.windows_vm_details["offer"]
    sku       = var.windows_vm_details["sku"]
    version   = var.windows_vm_details["version"]
  }

  depends_on = [azurerm_network_interface.jumpbox_vm_nic]
}