#Requires -Version 7.0

# see : https://github.com/microsoft/winget-create/blob/v0.1.0.1-preview/src/WingetCreateCore/Common/PackageParser.cs#L70
function Get-InstallerInfo ([string]$Uri) {
    $localPath = [System.IO.Path]::GetTempFileName()
    try {
        # download temporary
        Invoke-WebRequest -Uri $Uri -OutFile $localPath
        # get version
        $item = Get-Item -LiteralPath $localPath
        # get hash
        $hash =  Get-FileHash -LiteralPath $localPath -Algorithm SHA256
        return [ordered]@{
            InstallerUrl = $Uri;
            PackageVersion = if ($item.VersionInfo.FileVersion) {$item.VersionInfo.FileVersion} else {$item.VersionInfo.ProductVersion}
            InstallerSha256 = $hash.Hash
        }
    } finally {
        if (Test-Path -LiteralPath $localPath -PathType Leaf) {
            Remove-Item -LiteralPath $localPath
        }
    }
}

# WIP
function Find-LocalManifest () {
    $manifestRoot = Join-Path (Split-Path -Path $PSScriptRoot -Parent) 'manifests'
    Get-ChildItem -LiteralPath $manifestRoot -Directory | 
        ForEach-Object {
            $manifestPath = Join-Path -Path $_.FullName "$($_.Name).yaml"
            if (Test-Path -LiteralPath $manifestPath) {
                # version
                $version = (Get-Content $manifestPath) | 
                    Select-String 'PackageVersion:' | ForEach-Object { ($_ -split ':')[1].Trim() }
            }
            [PSCustomObject]@{
                Name = $_.Name
                Version = $version
            }
        }
}