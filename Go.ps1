while ($true) {
    . $(Join-Path -Path $(Split-Path -Parent -Path $MyInvocation.MyCommand.Definition) -ChildPath "Init.ps1")
    #$InvocationPath = $MyInvocation.MyCommand.Definition

    $CurrentIP = Get-PublicIP
    Write-Host -ForegroundColor Magenta "$(Get-Date -Format s) - Current IP is : $CurrentIP"

    $SplittedDNS = @()

    foreach ($Record in $State.records.keys) {
        $SplittedDNS += Split-DNS -DNS $Record
    }

    foreach ($Domain in $($SplittedDNS | Select-Object Domain -Unique).Domain) {
        $CloudFlareDNSRecords = Get-CloudFlareZoneDNSRecord -ZoneID $(Get-CloudFlareZone | Where-Object { $_.name -eq $Domain }).id
        foreach ($CloudFlareDNSRecord in $($CloudFlareDNSRecords | Where-Object { $($State.records.keys) -contains $_.name })) {
            Write-Host -NoNewline -ForegroundColor Yellow "$(Get-Date -Format s) - Updating $($CloudFlareDNSRecord.name) ... "
            if ($CloudFlareDNSRecord.type -ne $($State.records.$($CloudFlareDNSRecord.name).type)){
                Write-Host -NoNewline -ForegroundColor Gray "$(Get-Date -Format s) - Skipping because the type is not matching."
                continue
            }
            if ($CloudFlareDNSRecord.content -ne $CurrentIP) {
                Update-CloudFlareZoneDNSRecord -Type $($State.records.$($CloudFlareDNSRecord.name).type) -ZoneID $CloudFlareDNSRecord.zone_id -RecordID $CloudFlareDNSRecord.id -Content $CurrentIP | Out-Null
                Write-Host -NoNewline -ForegroundColor Green "`r$(Get-Date -Format s) - Updating $($CloudFlareDNSRecord.name) ... Updated !"
            }
            else { Write-Host -NoNewline -ForegroundColor Gray "`r$(Get-Date -Format s) - Updating $($CloudFlareDNSRecord.name) ... No update needed !" }
            Write-Host ""
        }
    }
    Write-Host -ForegroundColor Magenta "$(Get-Date -Format s) - Going back to sleep ..."
    Start-Sleep -Seconds $env:AppConfig_Sleep
}