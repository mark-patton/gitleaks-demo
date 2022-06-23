variable "rg_name" {
  type    = string
  default = "jumpbox_VMs"
}

variable "location" {
  type    = string
  default = "northeurope"
}

variable "subnet_rg" {
  type    = string
  default = "Management_Core"
}

variable "nic_name" {
  type    = string
  default = "windows_vm_nic"
}

variable "windows_vm_name" {
  type    = string
  default = "windows-jumpbox"
}

variable "windows_vm_size" {
  type    = string
  default = "Basic_A2"
}

variable "windows_vm_details" {
  type = map(any)
  default = {
    "publisher" = "MicrosoftWindowsServer"
    "offer"     = "WindowsServer"
    "sku"       = "2016-Datacenter"
    "version"   = "latest"
  }
}
