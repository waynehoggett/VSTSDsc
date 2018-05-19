[DscResource()]
class VSTSAgent {
    [DscProperty(Key)]
    [string]$Pool

    [DscProperty(Key)]
    [string]$Path

    [DscProperty(Mandatory)]
    [string]$PAT

    [DscProperty(Mandatory)]
    [string]$Uri

    [DscProperty(NotConfigurable)]
    [string]$ServiceName

    [void]Set(){

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
            Path = $This.Path
            Uri = $This.Uri
        }

    }
}