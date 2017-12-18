$SearchRoot = [ADSI]"LDAP://CN=Computers,DC=Contoso,DC=Corp"
$Filter = "(objectcategory=computer)"
$Properties = "name"  
$ICMPCheck = ""
$AWS_Enabled = import-module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"
$AZ_Enabled = Import-Module AzureRM
