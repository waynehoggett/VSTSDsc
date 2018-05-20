[DscResource()]
class VSTSAgent {
    [DscProperty(Key)]
    [string]$Pool

    [DscProperty(Key)]
    [string]$DestinationPath

    [DscProperty(Mandatory)]
    [string]$PAT

    [DscProperty(Mandatory)]
    [string]$AgentUri

    [DscProperty(Mandatory)]
    [string]$AccountUri

    [DscProperty(NotConfigurable)]
    [string]$ServiceName

    [void]Set(){

        #Check the path exists
        if (-not (Test-Path $this.DestinationPath -ErrorAction SilentlyContinue)) {
            throw "Path $($this.DestinationPath) is not valid"
        }

        #Check the path is a directory
        if (((Get-Item -Path "$($This.DestinationPath)" -ErrorAction SilentlyContinue).GetType().Name) -ne  "DirectoryInfo") {
            throw "DestinationPath $($This.DestinationPath) must be a directory"
        }

        #Check the AgentUri is valid
        if ($($This.AgentUri) -notlike "http*://*") {
            throw "Uri: $($This.AgentUri) must be a valid Uri"
        }

        #Check the AccountUri is valid
        if ($($This.AccountUri) -notlike "http*://*") {
            throw "Uri: $($This.AccountUri) must be a valid Uri"
        }

        #Download File
        try {
            (New-Object System.Net.WebClient).DownloadFile($This.AgentUri, "$($this.DestinationPath)\agent.zip")
        } catch {
            throw "Failed to download agent from $($This.AgentUri) to $($this.DestinationPath)"
        }

        #Unblock File
        Unblock-File -Path "$($this.DestinationPath)\agent.zip"

        #Expand Archive
        try {
            Expand-Archive -Path "$($this.DestinationPath)\agent.zip" -DestinationPath "$($this.DestinationPath)\"
        } catch {
            throw "Failed to extract $($this.DestinationPath)\agent.zip to $($this.DestinationPath)"
        }

        #Run Installer
        try {
            Start-Process -FilePath "$($this.DestinationPath)\config.cmd" -ArgumentList "--url `"$($This.AccountUri)`" --auth pat --token `"$($this.PAT)`" --unattended --pool `"$($this.Pool)`" --runAsService"
        } catch {
            throw "Failed to configure the VSTS Agent"
        }

    }

    [bool]Test() {
        try {
            Write-Verbose "Finding process names `"AgentService`" and `"Agent.Listener`""
            if ((Get-Process -Name "Agent.Listener","AgentService").Count -eq 2) {
                return $true 
            } else {
                return $false
            }
        } catch {
            throw "Could not find process names `"AgentService`" and `"Agent.Listener`""
        }

    }

    [VSTSAgent]Get() {

        try {
            Write-Verbose "Attempting to find the VSTS Service by searching for a service with a name like 'VSTSAgent'"
            $this.ServiceName = "$((Get-Service | Where-Object {$_.Name -Like "*VSTSAgent*"}).ServiceName)"
        } catch {
            throw "Could not find VSTS Service by searching for a service with a name like 'VSTSAgent'"
        }

        return @{
            Pool = $This.Pool
            DestinationPath = $This.DestinationPath
            AgentUri = $This.AgentUri
            AccountUri = $This.AccountUri
            ServiceName = $This.ServiceName
        }

    }
}