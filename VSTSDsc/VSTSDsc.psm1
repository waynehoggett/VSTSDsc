[DscResource()]
class VSTSAgent {
    [DscProperty(Key)]
    [string]$Path

    [DscProperty(Key)]
    [string]$PAT

    [DscProperty(Key)]
    [string]$Uri

    [void]Set(){

    }

    [bool]Test() {
        return $true
        #TODO: Update method
    }

    [VSTSAgent]Get() {
        return @{
            Path = $This.Path
            Uri = $This.Uri
        }

    }
}