# VSTSDsc
A class-based Desired State Configuration Resource to deploy the VSTS Agent

## Resources

### VSTSAgent

#### Parameters

* Pool (String, Required) - The Agent pool for which to add this agent to
* DestinationPath (String, Required) - The local file path where the agent will be deployed to, must be a directory
* PAT (String, Required) - The Personal Access Token for the user that will be used to register the VSTS Agent 
* AgentUri (String, Required) - The URL where the Agent can be downloaded from
* AccountUri (String, Required) - The URL of the VSTS Account

#### Examples

```powershell
VSTSAgent VSTSAgentInstall #ResourceName  
{  
    DestinationPath = "C:\Agent\"  
    PAT = "wt26usi4zdhqagzyb4xvox2fq362qlqet4a3o2veej2brbmgapja"  
    Pool = "Default"  
    AgentUri = "https://vstsagentpackage.azureedge.net/agent/2.133.3/vsts-agent-win-x64-2.133.3.zip"
    AccountUri = "https://waynehoggett.visualstudio.com"  
}  
```

## Planned Future Releases

0.4 - Support of running interactively (not as a service)  
0.3 - Support for changing the agent name and working directory  
0.2 - Pester tests for the module, clean-up zip file, add ensure to support uninstall, BREAKING - PAT should be of type PSCredential  
0.1 - The ability to deploy the vsts agent on Windows Server 2016 running PowerShell 5.1  


## Related Links

Deploy an agent on Windows - https://docs.microsoft.com/en-us/vsts/build-release/actions/agents/v2-windows  
vsts-agent - https://github.com/Microsoft/vsts-agent  
Build and Release Agents - https://docs.microsoft.com/en-us/vsts/build-release/concepts/agents/agents  
