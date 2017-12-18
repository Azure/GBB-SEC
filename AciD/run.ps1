. .\Params\config.ps1

$AZ_Enabled #Enter $AZ_Enabled for Azure connection or $AWS_Enabled for AWS.

$Searcher = New-Object DirectoryServices.DirectorySearcher($SearchRoot, $Filter)  
$Searcher.PageSize = 1000  
$Searcher.PropertiesToLoad.AddRange($Properties)  
$Searcher.FindAll() | Select-Object `
@{n='Name';e={ $_.Properties["name"][0] }} ,
@{n='UP?';e={ if(test-connection $_.Properties["name"][0] -q -count 2) {$True} Else {$False} }}  | ConvertTo-Csv -NoTypeInformation | % { $_ -replace '"', ""}  | out-file $ICMPCheck -fo -en ascii
$filename= $ICMPCheck
$outputfile="$filename" + ".log"