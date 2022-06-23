################################################################################################################################################################
### RESOURCE GROUP Cleardown:
### Script is used to clear down resource group deployments.  When the number of deployments reaches 800 no further deployments can be made to a resource group.
### This script was initially designed to display the number of Resource Group Deployments of all Resource Groups, and delete those Deployments where the 
### total number exceeded the safelimit
################################################################################################################################################################ 

### Only items in this section should be changed ###
$safelimit = 625 # clear down takes place when the number of deployments are great than or equal to this
$cleardownlevel = 600 # the level at which deployments will be cleared-down to
$SEARCHCRITERIA = '*' # wildcard naming for Resource Group can be used - applies to deletion step only

### Note: the commented section, lines 31-35, should remain in place and the script run.  When satisfied that figures are correct, remove comments and proceed to 
### remove the Resource Group Deployments.
### This script comes with no warranty.
####################################################

Get-AzureRmResourceGroup |  ForEach-Object {
    $deployments = Get-AzureRmResourceGroupDeployment -ResourceGroupName $_.ResourceGroupName #get the deployments for the resource group
    Write-Host "`n"$_.ResourceGroupName": "$deployments.Count
    
	# only remove deployments when they are above the agreed safe limit and are associated with the your solution
    if ($deployments.Count -ge $safelimit -and $_.ResourceGroupName -like $SEARCHCRITERIA) { 
        Write-Host "  >>"$_.ResourceGroupName"deployments to be cleared." -ForegroundColor Yellow

        $sortedDeployments = $deployments | Sort-Object TimeStamp #sort in order to remove the oldest
        $count = $deployments.Count
        write-host "  >> count: $count"
        
        write-host "  >> cleardownlevel: $cleardownlevel"
        <# for ($i=0; $i -lt ($count - $cleardownlevel)) {
           write-host "Removing deployment "$sortedDeployments[$i].DeploymentName
           Remove-AzureRmResourceGroupDeployment -ResourceGroupName $_.ResourceGroupName -Name $sortedDeployments[$i].DeploymentName #remove the deployment
           $i++
        } #># << uncomment this section when you are sure you're ready to delete the resource group deployments - it's recommended you run before uncommenting 
    }
} 
