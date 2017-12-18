Get-Module PowerShellGet -list | Select-Object Name,Version,Path #Check to see if Azure Powershell module is installed/version rev
#Uncomment below if you need to install Azure Powershell module
#Install-Module AzureRM -AllowClobber 
Import-Module AzureRM #Run PS w/Azure Module