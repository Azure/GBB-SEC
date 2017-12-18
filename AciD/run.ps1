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

#Query AWS for instances based on tag - presumably environment, domain, etc.
$Instances = (Get-EC2Instance -Filter @( @{name='tag:Name'; values="Value"})).instances 
$VPCS = Get-EC2Vpc
$export = foreach ($VPC in $VPCS) {
     $Instances | Where-Object {$_.VpcId -eq $VPC.VpcId} | foreach {
        New-Object -TypeName PSObject -Property @{
            'FQDN' = ($_.Tags | Where-Object {$_.Key -eq 'Value'}).Value 
        
        } 
    } 
} 
$export | Export-Csv $awslist -NoTypeInformation


##This section setups up AD module, imports list of computers from CSV and loads into variable. Based on target path it then moves computer to new OU.
## Import AD Module if Does not Exist 
if (! (get-Module ActiveDirectory)) 
{ 
Write-Host "Importing AD Module....." -Fore green 
Import-Module ActiveDirectory 
Write-Host "Completed..............." -Fore green 
} 
 
 
## Adding Variables 
$Space   =  Write-Host "" 
$Sleep   =  Start-Sleep -Seconds 3 
 
## Reading list of computers from csv and loading into variable  
$computers = Get-Content C:\[$ClientFolder]\Outputs\ListDone.csv
$path      = "C:\[$ClientFolder]\Outputs\ListDone.csv" 
## verification 
if (! (Test-Path $Path)) { 
     
    Write-Host "List of computers  List txt does not exist" 
 
} 
 
## Defining Target Path  
$TargetOU   =  "OU=Pending Delete,DC=OU,DC=OU,DC=com"  
$countPC    = ($computers).count  
 
$Space   =  Write-Host "" 
$Sleep   =  Start-Sleep -Seconds 3 
write-host "This Script will move Computer Accounts" -Fore green 
write-host "Destination location is (OU=Pending Delete)     " -Fore green 
 
## Provide details 
write-host "List of Computers............." -Fore green 
$computers 
write-host ".............................." -Fore green 
$Space   
$Sleep 
ForEach( $computer in $computers){ 
    write-host "moving computers..." 
    Get-ADComputer $computer | 
    Move-ADObject -TargetPath $TargetOU 
} 
 
$Space   
$Sleep 
write-host "Completed....................." -Fore green 
Write-Host "Moved $countPC Servers........" 
Write-Host "Destination OU $TargetOU......"



Remove-Item $awslist



