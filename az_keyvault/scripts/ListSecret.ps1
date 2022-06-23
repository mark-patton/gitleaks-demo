 Function List-Secret{
    
    # Receive passed-through parameters from the List-Secret <keyVaultName> <searchTerm>
    # The string parameters received are case-insensitive
    param( [string]$keyVaultName, [string]$searchTerm )
    
    
    # Get secrets from vault based on search criteria stipulated in $searchTerm
    $secrets = Get-AzureKeyVaultSecret -VaultName $keyVaultName | where {$_.Name -like $searchTerm}
    
    # Print to console...
    $secrets | ForEach-Object{
        
        # ... the name of the Key Vault secret
        write-host "`n`n"$_.Name -BackgroundColor Cyan -ForegroundColor Black
    
        # ... the value of the secret
        $secretValueText = (Get-AzureKeyVaultSecret -VaultName $keyVaultName -Name $_.Name).SecretValueText
        Write-Host $secretValueText
    }
} 
