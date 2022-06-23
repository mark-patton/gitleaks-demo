# Azure Bastion - README

This document explains the steps to deploying Azure Bastion from this Repository.  Steps include:

1. Deploying Azure Bastion
1. Deploying VM to vNet


## Deploy via Terraform

### Terraform Version

The examples included within this repository support the following Terraform version:

```
Terraform v0.12.20
+ provider.azurerm v2.0.0
```

### Authenticating to Azure Subscription

In preparation for common use and access, Terraform is granted rights to your Azure subscription via Azure CLI.  Please use the following steps:

1. Login to Azure
```
az login
```
2. Set your Azure Subscription
```
az account set --subscription {subscription_id}
```

### Deploy Azure Bastion

1. Initialise Terraform - ensure working directory is ```/codesamples/az_bastion/terraform```
```
terraform init
```
2. Confirm resources to be deployed
```
terraform plan
```
3. Deploy Azure Bastion
```
terraform apply
```

### Deploy VM 

1. Change working directory to ```/codesamples/az_bastion/terraform/az_vm```
2. Initialise Terraform
```
terraform init
```
3. Confirm resources to be deployed
```
terraform plan
```
4. Deploy VM to vNet
```
terraform apply
```


## Deploy via Powershell

Using Powershell, run the Powershell script ```/codesamples/az_bastion/powershell/az_bastion.ps1```
