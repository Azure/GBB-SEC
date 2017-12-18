Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Set-Location C:\[$ClientFolder]
. .\Params\config.ps1
import-module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"

$Searcher = New-Object DirectoryServices.DirectorySearcher($SearchRoot, $Filter)  
$Searcher.PageSize = 1000  
$Searcher.PropertiesToLoad.AddRange($Properties)  
$Searcher.FindAll() | Select-Object `
@{n='Name';e={ $_.Properties["name"][0] }} ,
@{n='UP?';e={ if(test-connection $_.Properties["name"][0] -q -count 2) {$True} Else {$False} }}  | ConvertTo-Csv -NoTypeInformation | % { $_ -replace '"', ""}  | out-file $ICMPCheck -fo -en ascii
$filename= $ICMPCheck
$outputfile="$filename" + ".log"