# useful-tools

## Write-Log.ps1
This is straight from http://psappdeploytoolkit.com and is probably the single best logging function for PowerShell I've ever seen. All credit to the team there. https://psappdeploytoolkit.com/about/

## Import-RegistryFile.ps1
This PowerShell function reads a .reg file, validates it looks like a registry export, parses keys ([...]) and name=value lines, and returns an array of PSCustomObjects describing each registry entry (Key, Name, Value, Type). It does not write to the Windows registry — it only converts the .reg file contents into PowerShell objects.