# VSTSDsc
A class-based Desired State Configuration Resource to deploy the VSTS Agent

## Example

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
0.2 - Pester tests for the module, remove zip file, add ensure to support uninstall  
0.1 - The ability to deploy the vsts agent on Windows Server 2016 running PowerShell 5.1  


## Related Links

Deploy an agent on Windows - https://docs.microsoft.com/en-us/vsts/build-release/actions/agents/v2-windows  
vsts-agent - https://github.com/Microsoft/vsts-agent  
Build and Release Agents - https://docs.microsoft.com/en-us/vsts/build-release/concepts/agents/agents  
