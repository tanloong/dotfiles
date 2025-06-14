function Link-File {
    param (
        [string]$FROM,
        [string]$TO
    )

    if (-not (Test-Path $FROM)) {
        Write-Error "Source path '$FROM' does not exist."
        return
    }

    $linkType = if ((Get-Item $FROM).PSIsContainer) { 'Directory' } else { 'SymbolicLink' }

    $linkDir = Split-Path -Parent $TO
    New-Item -ItemType Directory -Path $linkDir -Force | Out-Null

    if (Test-Path $TO) {
        Remove-Item $TO -Recurse -Force
    }

    # For directories, use Junctions (more compatible on Windows if not in Developer Mode)
    if ($linkType -eq 'Directory') {
        New-Item -ItemType Junction -Path $TO -Target $FROM | Out-Null
    } else {
        New-Item -ItemType SymbolicLink -Path $TO -Target $FROM | Out-Null
    }

    Write-Host "Linked '$TO' -> '$FROM'"
}


$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Link-File -FROM (Join-Path $winDir ".windows" "profile.ps1") -TO $PROFILE
Link-File -FROM (Join-Path $scriptDir ".gitconfig") -TO "$env:USERPROFILE\.gitconfig"
Link-File -FROM (Join-Path $scriptDir ".config" "nvim") -TO "$env:LOCALAPPDATA\nvim"
Link-File -FROM (Join-Path $scriptDir ".config" "nushell") -TO "$env:APPDATA\nushell"
