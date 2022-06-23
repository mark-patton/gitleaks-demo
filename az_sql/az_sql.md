__Brought to you by <https://markpatton.cloud>__

# Azure SQL Database - Highly Available Endpoints

This ReadMe will take you through how to deploy the template ```sql.json``` with the associated parameters file ```nonprod.sql.parameters.json```.  This will deploy a Highly-Available database resource hosted efficiently within an Elastic Pool.

## Features of this ARM Template

The features of this deployment are as follows:

1. SQL Database deployed within Elastic Pools
2. Active Geo-Replication
3. Auto Failover Groups
4. Advanced Threat Protection
    * SQL Injection
    * SQL Injection Vulnerability
    * Data Exfiltration
    * Unsafe Action
    * Brute Force
    * Anomalous Client Login
5. Vulnerability Assessments
6. Auditing to Blob Storage
7. Azure AD Secure Logins
8. Backups - Long Term Retention and Point in Time Restore

## PreRequisites

Before deploying this template, you should ensure the following pre-requisites are in place:

1. Security Group
 * Create a Security Group for your ```SQL Admins```.  Users you assign to this group will be given Administrator access to the SQL databases which are deployed

2. Key Vault - Secrets
   * ```aadtenantid``` - create a secret in the KeyVault with the tenant id of your Azure Active Directory Tenant.  This will be required for referencing the 'SQL Admins' security group define aboved
   * ```pwd<<db_name_>>api``` - create a secret with the password for each of your environments - this is used to create the local account on the SQL Database through which your API will connect
   * ```SQLAdminGroupSid``` - create a secret with the ObjectID of the Security Group created in AAD for your Admin users.  This is referenced in the parameters file

   *Remember: update the references in the parameters file for the KeyVault with the resourceID of your own provisioned KeyVault*

Note: this ARM Template will build connection strings for your database service and store in the KeyVault which you can reference when deploying your APIApps or other App Services.  Because a secure string cannot be read from the vault and pushed back again - *for the purpose of adding the password to the connection string without storing the password in your template* - it will securely output the password which you can pull in to your CD pipeline. Within the connection string formed in KeyVault, the password has been set with ```---```.  You can use ```.replace('---',<<your_password>>)``` to update the connection string in your pipeline.

### Instructions
The template will store a secret to the KeyVault similar to the following:
```c#
Server=tcp:fgfinancedev.database.windows.net,1433;Initial Catalog=financedev;Persist Security Info=False;User ID='financedev_api';Password='---';MultipleActiveResultSets=False;Encrypt=True;Max Pool Size=200;TrustServerCertificate=False;Connection Timeout=20;
```

In your pipeline, you can replace the ```---``` with your password as follows (PowerShell embedded with YAML - use as required):
```yaml
variables:
  vaultname: 'KeyVaultName'

steps:
  task: AzurePowerShell@3
  displayName: 'Azure PowerShell script: Add Password to Connection String'
  inputs:
    azureSubscription: 'MarkPattonCloud'
    ScriptType: InlineScript
    Inline: |
     $json = '$(ARMoutput)' | ConvertFrom-Json
     
     $length = $json.secretarray.value.length
     write-host "Length: "$length
     for($i=0; $i -lt $length; $i++){
     
        # Get password from KeyVault Secret
        write-host "Obtaining secret: "$json.secretarray.value[$i].secretname  -BackgroundColor Cyan -ForegroundColor Black
        $pwd = Get-AzureKeyVaultSecret -VaultName $(vaultname) -Name $json.secretarray.value[$i].secretname
        write-host "Password obtained from the vault $(vaultname) for "$json.secretarray.value[$i].secretname  -BackgroundColor Cyan -ForegroundColor Black
      
        # Get connection string to inject password
        $secret = "connstr"+$json.secretarray.value[$i].name
        $connstr = Get-AzureKeyVaultSecret -VaultName $(vaultname) -Name $secret
        $updatedsecret = $connstr.SecretValueText
     
        write-host "Setting connection string with password!" 
        $newconnstr = $updatedsecret.replace('---',$pwd.SecretValueText)
        $encryptedsecret = ConvertTo-SecureString -String $newconnstr -AsPlainText -Force
        Set-AzureKeyVaultSecret -VaultName $(vaultname) -Name $secret -SecretValue $encryptedsecret
        write-host "Connection has been updated and is ready for use!"    
     }
     
    azurePowerShellVersion: LatestVersion
```


## Tailoring the Template to your needs

1. In the parameters file, note the codeblock ```DatabaseSettings```.  This is used to configure the settings for each deployed database to the instance created.

```json
{
            "name": "<<databasename>>",
            "username": "<<sqluser>>",
            "secretname": "<<sqluserpassword>>",
            "backup": "<<true/false>>",
            "env": "<<environment/identifier>>"
}
```

 * ```name``` defines the name of the database
 * ```username``` is the identity through which your API will connect to the database
 * ```secretname``` is the name of the secret in the KeyVault containing the password which will be set for the user created in the database
 * ```backup``` is a boolean value used to define whether you wish for the database to be backed-up on a routine bases
 * ```env``` is used to apply appropriate Azure ```Tag``` in the portal and to name certain resources accordingly throughout the solution

As the Parameter ```DatabaseSettings``` is an array, you can add numerous blocks of this JSON to deploy any number of databases you wish your solution to have, within Azure limits of course.

Here's an example:

```json
"databasesettings": {
    "value": [
      {
        "name": "financedev",
        "username": "financedev_api",
        "secretname": "pwddevapi",
        "backup": false,
        "env": "dev"
      },
      {
        "name": "financepreprod",
        "username": "financepreprod_api",
        "secretname": "pwdpreprodapi",
        "backup": false,
        "env": "preprod"
      }
    ]
}
```

## Deploying the Template

Once your template and associated parameter files have been prepared, and the prerequisites completed, you are ready to deploy.  There are a number of ways you can initiate the deployment, however, the following will be familiar to many.

Firstly, validate the syntax of your template:

```bash
az group deployment validate --resource-group <<YourResourceGroupName>> --template-file ./sql.json --parameters nonprod.sql.parameters.json
```

Finally, in order to deploy, run the following command:

```bash
az group deployment create --resource-group <<YourResourceGroupName>> --template-file ./sql.json --parameters nonprod.sql.parameters.json
```

Feel free to check out my website <https://markpatton.cloud> for news, articles and more.
