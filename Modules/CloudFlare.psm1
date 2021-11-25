function Get-CloudFlareZone (){
    $Headers = @{
        "Content-Type" = "application/json"
        "X-Auth-Email" = $env:CloudFlare_Email
        "X-Auth-Key" = $env:CloudFlare_APIKey
    }
    $Response = ((Invoke-WebRequest -Headers $Headers -Uri "https://api.cloudflare.com/client/v4/zones").Content | ConvertFrom-Json).result
    
    return $Response
}
function Get-CloudFlareZoneSetting ($ZoneID){
    $Headers = @{
        "Content-Type" = "application/json"
        "X-Auth-Email" = $env:CloudFlare_Email
        "X-Auth-Key" = $env:CloudFlare_APIKey
    }
    $Response = ((Invoke-WebRequest -Headers $Headers -Uri "https://api.cloudflare.com/client/v4/zones/$ZoneID/settings").Content | ConvertFrom-Json).result
    
    return $Response
}
function Get-CloudFlareZoneDNSRecord ($ZoneID){
    $Headers = @{
        "Content-Type" = "application/json"
        "X-Auth-Email" = $env:CloudFlare_Email
        "X-Auth-Key" = $env:CloudFlare_APIKey
    }
    $Response = ((Invoke-WebRequest -Headers $Headers -Uri "https://api.cloudflare.com/client/v4/zones/$ZoneID/dns_records?per_page=999").Content | ConvertFrom-Json).result
    
    return $Response
}
function New-CloudFlareZoneDNSRecord ($ZoneID,$Type,$Name,$Content,$TTL,$Priority,$Proxied){
    $Headers = 
    $Headers = @{
        "Content-Type" = "application/json"
        "X-Auth-Email" = $env:CloudFlare_Email
        "X-Auth-Key" = $env:CloudFlare_APIKey
    }
    $Body = New-Object -TypeName PSObject
    $Body | Add-Member -Type NoteProperty -Name 'type' -Value $Type
    $Body | Add-Member -Type NoteProperty -Name 'name' -Value $Name
    $Body | Add-Member -Type NoteProperty -Name 'content' -Value $Content
    if (![string]::IsNullOrEmpty($TTL)){$Body | Add-Member -Type NoteProperty -Name 'ttl' -Value $TTL}else{$Body | Add-Member -Type NoteProperty -Name 'ttl' -Value 1}
    if (![string]::IsNullOrEmpty($Priority)){$Body | Add-Member -Type NoteProperty -Name 'priority' -Value $Priority}
    if (![string]::IsNullOrEmpty($Proxied)){$Body | Add-Member -Type NoteProperty -Name 'proxied' -Value $Proxied}else{$Body | Add-Member -Type NoteProperty -Name 'proxied' -Value $true}

    $Response = ((Invoke-WebRequest -Method Post -Body $($Body | ConvertTo-Json) -Headers $Headers -Uri "https://api.cloudflare.com/client/v4/zones/$ZoneID/dns_records").Content | ConvertFrom-Json).result
    
    return $Response
}
function Update-CloudFlareZoneDNSRecord ($ZoneID,$RecordID,$Type,$Name,$Content,$TTL,$Proxied){
    $Headers = 
    $Headers = @{
        "Content-Type" = "application/json"
        "X-Auth-Email" = $env:CloudFlare_Email
        "X-Auth-Key" = $env:CloudFlare_APIKey
    }
    $Body = New-Object -TypeName PSObject
    if (![string]::IsNullOrEmpty($Type)){$Body | Add-Member -Type NoteProperty -Name 'type' -Value $Type}
    if (![string]::IsNullOrEmpty($Name)){$Body | Add-Member -Type NoteProperty -Name 'name' -Value $Name}
    if (![string]::IsNullOrEmpty($Content)){$Body | Add-Member -Type NoteProperty -Name 'content' -Value $Content}
    if (![string]::IsNullOrEmpty($TTL)){$Body | Add-Member -Type NoteProperty -Name 'ttl' -Value $TTL}
    if (![string]::IsNullOrEmpty($Proxied)){$Body | Add-Member -Type NoteProperty -Name 'proxied' -Value $Proxied}

    $Response = ((Invoke-WebRequest -Method Patch -Body $($Body | ConvertTo-Json) -Headers $Headers -Uri "https://api.cloudflare.com/client/v4/zones/$ZoneID/dns_records/$RecordID").Content | ConvertFrom-Json).result
    
    return $Response
}

Export-ModuleMember -Function *