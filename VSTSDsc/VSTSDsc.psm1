[DscResource()]
class VSTSAgent {
    [DscProperty(Key)]
    [string]$Pool

    [DscProperty(Key)]
    [string]$DestinationPath

    [DscProperty(Mandatory)]
    [string]$PAT

    [DscProperty(Mandatory)]
    [string]$Uri

    [DscProperty(NotConfigurable)]
    [string]$ServiceName

    [void]Set(){

        #Check the path exists
        if (-not (Test-Path $this.Path -ErrorAction SilentlyContinue)) {
            throw "Path $($this.DestinationPath) is not valid"
        }

        #Check the path is a directory
        if (Get-Item -Path $($This.Path) -is [System.IO.FileInfo]) {
            throw "DestinationPath $($This.Path) must be a directory"
        }

        #Check the Uri is valid
        $regex = "http*://*"
        if ($this.Uri -notmatch $regex) {
            throw "Uri: $($This.uri) must be a valid Uri"
        }

        #Download File
        try {
            (New-Object System.Net.WebClient).DownloadFile($This.Uri, "$($this.DestinationPath)\agent.zip")
        } catch {
            throw "Failed to download agent from $($This.Uri) to $($this.DestinationPath)"
        }

        #Unblock File
        Unblock-File -Path "$($this.DestinationPath)\agent.zip"

        #Expand Archive
        try {
            Expand-Archive -Path "$($this.DestinationPath)\agent.zip" -DestinationPath "."
        } catch {
            throw "Failed to extract $($this.DestinationPath)\agent.zip to $($this.DestinationPath)"
        }

        #Run Installer
        try {
            Start-Process -FilePath "$($this.DestinationPath)\config.cmd" -ArgumentList "--url `"$($this.Uri)`" --auth pat --token `"$($this.PAT)`" --unattended --pool `"$($this.Pool)`" --runAsService"
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
            Path = $This.DestinationPath
            Uri = $This.Uri
        }

    }
}