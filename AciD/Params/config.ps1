Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Set-Location 'C:\'

$SearchRoot = [ADSI]"LDAP://CN=Computers,DC=Contoso,DC=Corp"
$Filter = "(objectcategory=computer)"
$Properties = "name"  

$ICMPCheck = ""

$AWS_Enabled = Import-Module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"
$AZ_Enabled = Import-Module AzureRM
