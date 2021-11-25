. $(Join-Path -Path $(Split-Path -Parent -Path $MyInvocation.MyCommand.Definition) -ChildPath "Init.ps1")
#$InvocationPath = $MyInvocation.MyCommand.Definition

$CurrentIP = Get-PublicIP

$SplittedDNS = @()

foreach ($Record in $State.records) {
    $SplittedDNS += Split-DNS -DNS $Record
}

foreach ($Domain in $($SplittedDNS | Select-Object Domain | Get-Unique).Domain){
    $CloudFlareDNSRecords = Get-CloudFlareZoneDNSRecord -ZoneID $(Get-CloudFlareZone | Where-Object {$_.name -eq $Domain}).id
    foreach ($CloudFlareDNSRecord in $($CloudFlareDNSRecords | Where-Object {$($State.records) -contains $_.name})){
        Update-CloudFlareZoneDNSRecord -ZoneID $CloudFlareDNSRecord.zone_id -RecordID $CloudFlareDNSRecord.id -Content $CurrentIP
    }
}