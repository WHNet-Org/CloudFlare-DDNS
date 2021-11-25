function Check($Path){
    if (!$(Test-Path $Path -PathType leaf))
    {
        throw "Variable file not found !"
        exit
    }
}
function Get-PublicIP(){
    return $(((Invoke-WebRequest -Uri "https://1.1.1.1/cdn-cgi/trace").Content | ConvertFrom-StringData).ip)
}

function Split-DNS ($DNS){
    $Response = [PSCustomObject]@{
        TLD = $($DNS.Split('.')[-1]).ToLower()
        Domain = $("$($DNS.Split('.')[-2]).$($DNS.Split('.')[-1])").ToLower()
        Subdomain = $("$($DNS.Split(".$("$($DNS.Split('.')[-2]).$($DNS.Split('.')[-1])")"))").ToLower()
    }
    return $Response
}

function Initialize-EnvironmentVariables ([hashtable]$Variables) {
    foreach ($EnvVar in $Variables.Keys) {
        If (![string]::IsNullOrEmpty($Global:EnvFile[$EnvVar])) {
            # Set variable to Env.ps1 value
            [Environment]::SetEnvironmentVariable($EnvVar, $Global:EnvFile[$EnvVar], 'Process')
        }
        Else {
            if (![string]::IsNullOrEmpty($([Environment]::GetEnvironmentVariable($EnvVar, 'Machine')))) {
                # Set variable to machine Env
                [Environment]::SetEnvironmentVariable($EnvVar, $([Environment]::GetEnvironmentVariable($EnvVar, 'Machine')), 'Process')
            }
            elseif (![string]::IsNullOrEmpty($([Environment]::GetEnvironmentVariable($EnvVar, 'Process')))) {
                # Set variable to process Env (Docker)
                [Environment]::SetEnvironmentVariable($EnvVar, $([Environment]::GetEnvironmentVariable($EnvVar, 'Process')), 'Process')
            }
            Else {
                # Set variable to default
                [Environment]::SetEnvironmentVariable($EnvVar, $EnvVars[$EnvVar], 'Process')
            }
        }
    }
}

Export-ModuleMember -Function *