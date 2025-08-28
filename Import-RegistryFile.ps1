function Import-RegistryFile {
    <#
    .SYNOPSIS
    Import a .reg file and convert it to a PowerShell object.

    .DESCRIPTION
    This function reads a .reg file, parses its contents, and converts it into a PowerShell object
    that represents the registry keys and values defined in the file.

    .PARAMETER FilePath
    The path to the .reg file to be imported.

    .EXAMPLE
    $registryObject = Import-RegistryFile -FilePath "C:\Path\To\File.reg"
    This command imports the specified .reg file and stores the resulting object in $registryObject.

    .NOTES
    Author: Joseph Ascanio
    Date: 2025-08-28
    Version: 1.0

    .LINK
    https://github.com/reave/useful-tools/blob/main/Import-RegistryFile.ps1

    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    if (-Not (Test-Path -Path $FilePath)) {
        throw "The file '$FilePath' does not exist."
    }

    $regContent = Get-Content -Path $FilePath -Raw

    if (-Not ($regContent -match '^\s*Windows Registry Editor Version')) {
        throw "The file '$FilePath' is not a valid .reg file."
    }

    $regEntries = @()
    $currentKey = $null

    foreach ($line in $regContent -split "`r?`n") {
        $line = $line.Trim()

        if ($line -match '^\[.*\]') {
            $currentKey = $line.Trim('[', ']')
        }
        elseif ($line -match '^(.*)=(.*)$' -and $currentKey) {
            $name, $value = $line -split '=', 2
            $type = $null

            if ($value -match '^"(.*)"$') {
                $type = 'String'
                $value = $value.Trim('"')
            }
            elseif ($value -match '^dword:(.*)$') {
                $type = 'DWORD'
                $value = $value.Substring(6)
            }
            elseif ($value -match '^hex:(.*)$') {
                $type = 'Binary'
                $value = $value.Substring(4)
            }
            else {
                $type = 'Unknown'
            }

            $regEntries += [PSCustomObject]@{
                Key   = $currentKey
                Name  = $name.Trim('"')
                Value = $value
                Type  = $type
            }
        }
    }

    return $regEntries
}