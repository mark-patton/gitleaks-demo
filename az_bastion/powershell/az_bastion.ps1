# Deployment location
$location = "northeurope"

# Create a resource group for Azure Bastion - Management Resource Group
$rg_Bastion = "Management_Core"
New-AzureRmResourceGroup -name $rg_Bastion -location $location

# Create vNet and Subnet - 'AzureBastionSubnet' is a prerequisite.  Minimal CIDR of /27
$subnetName = "AzureBastionSubnet"
$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 192.168.0.224/27
$vnet = New-AzVirtualNetwork -Name "mgmt_core_vnet" -ResourceGroupName $rg_Bastion -Location $location -AddressPrefix 192.168.0.0/16 -Subnet $subnet

# Create Public IP for Bastion
$publicip = New-AzPublicIpAddress -ResourceGroupName $rg_Bastion -name "azure_bastion_ip" -location $location -AllocationMethod Static -Sku Standard

# Create new Azure Bastion resource
$azbastion = New-AzBastion -ResourceGroupName $rg_Bastion -Name "azure_bastion_host" -PublicIpAddress $publicip -VirtualNetwork $vnet