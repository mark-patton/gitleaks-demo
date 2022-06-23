
# Create a new Azure DevOps Project
Function New-ADOProject ($proj) {

    $exists = az devops project show --project $proj

    if ( $exists -eq $null ) {

        Write-Host "Project does not exist."
        Write-Host "Creating project $proj..." 
        
        az devops project create --name $proj


    } else {        
        
        Write-Host "Project already exists."

    }

    $project_default = Read-Host "Set Project as default?"

    if ( $project_default -eq $true -OR $project_default -eq "true" -OR $project_default -eq 1 -OR $project_default -eq "yes" ) {
        Write-Host "Setting project as default"
        az devops configure --defaults project=$proj
    }

}

# Create a new Azure DevOps Repository
Function New-ADORepository ($repo) {

    $exists = az repos show --repository $repo

    if ( $exists -eq $null ) {

        Write-Host "Repository does not exist."
        Write-Host "Creating repository $repo..." 
        
        az repos create --name $repo

        return;

    } else {

        Write-Host "Repository already exists."
        return;

    }

}

# Set the CLI Azure DevOps Configuration
Function Set-ADOConfiguration ($org, $proj, $git) {

    if ( $org ) {

        Write-Host "Setting default Organization"
        az devops configure --defaults organization="https://dev.azure.com/$org"

    }
    
    if ( $proj ) {

        Write-Host "Setting default Project"
        az devops configure --defaults project="$proj"

    }
    
    if ( $git -eq "true" -OR $git -eq "false" ) {

        Write-Host "Updating use of Git aliases"
        az devops configure --use-git-aliases="$git"

    } elseif ($git -ne $null) {

        Write-Host "Invalid character used for configuring use of Git aliases: $git"

    }

}

# Get the CLI Configuration for Azure DevOps
Function Get-ADOConfiguration {

    Write-Host "ADO defaults configuration:"
    az devops configure --list

}

Function get-details {

    $Organization = Read-Host "Enter Organization name or URL"

    $Project = Read-Host "Enter Project name"



    If ( $Organization -like "https://" ) {

        Write-Host "URL received."
        $URL = $Project

    } Else {

        Write-Host "Organisation name received.  Forming URL..."

        $URL = "https://$Organization@dev.azure.com/$Project/"

    }

    Write-Host "Git URL registered as $URL"

    return $URL, $Organization, $Project
    
}