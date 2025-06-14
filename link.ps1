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


$currFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
Link-File -FROM (Join-Path $winDir ".windows" "profile.ps1") -TO $PROFILE
Link-File -FROM (Join-Path $currFolder ".gitconfig") -TO "$env:USERPROFILE\.gitconfig"
Link-File -FROM (Join-Path $currFolder ".config" "nvim") -TO "$env:LOCALAPPDATA\nvim"
Link-File -FROM (Join-Path $currFolder ".config" "nushell") -TO "$env:APPDATA\nushell"

$huma_char = Join-Path $currFolder ".local/share/fcitx5/table/huma-char.txt"
$huma_hop = Join-Path $currFolder ".local/share/nvim/lazy/hop.nvim/lua/hop/mappings/zh_huma.lua"
$gawk_script = Join-Path $currFolder "huma2hop.gawk"
if ( (Test-Path $huma_char) -and ( (-not (Test-Path $huma_hop)) -or ((Get-Item $huma_char).LastWriteTime -gt (Get-Item $huma_hop).LastWriteTime))) { & gawk -f $gawk_script -- $huma_char > $huma_hop }
Link-File -FROM $huma_hop -TO (Join-Path $env:LOCALAPPDATA "nvim-data\lazy\hop.nvim\lua\hop\mappings\zh_huma.lua")
