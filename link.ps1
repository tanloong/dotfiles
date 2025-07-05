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
Link-File -FROM (Join-Path $currFolder "windows" "profile.ps1") -TO $PROFILE
Link-File -FROM (Join-Path $currFolder ".gitconfig") -TO "$env:USERPROFILE\.gitconfig"
Link-File -FROM (Join-Path $currFolder ".config" "nvim") -TO "$env:LOCALAPPDATA\nvim"
Link-File -FROM (Join-Path $currFolder ".config" "nushell") -TO "$env:APPDATA\nushell"
Link-File -FROM (Join-Path $currFolder ".config" "uv") -TO "$env:APPDATA\uv"
Link-File -FROM (Join-Path $currFolder ".pip" "pip.conf") -TO "C:\ProgramData\pip\pip.ini"

# lf
Link-File -FROM (Join-Path $currFolder ".config" "lf" "icons") -TO "$env:LOCALAPPDATA\lf\icons"
Link-File -FROM (Join-Path $currFolder ".config" "lf" "lfrc") -TO "$env:LOCALAPPDATA\lf\lfrc"
# if (-not (Test-Path "$env:LOCALAPPDATA\lf\colors")) {Invoke-WebRequest -Uri "https://raw.githubusercontent.com/gokcehan/lf/master/etc/colors.example" -OutFile -FilePath "$env:LOCALAPPDATA\lf\colors" -Encoding utf8 -Force}

# gitui
Link-File -FROM (Join-Path $currFolder ".config" "gitui") -TO "$env:APPDATA\gitui"

# zh_huma.lua
$huma_char = Join-Path $currFolder ".local/share/fcitx5/table/huma-char.txt"
$huma_hop = Join-Path $currFolder ".local/share/nvim/lazy/hop.nvim/lua/hop/mappings/zh_huma.lua"
New-Item -ItemType Directory -Path (Split-Path -Parent $huma_hop) -Force | Out-Null
$gawk_script = Join-Path $currFolder "huma2hop.gawk"
if ( (Test-Path $huma_char) -and ( (-not (Test-Path $huma_hop)) -or ((Get-Item $huma_char).LastWriteTime -gt (Get-Item $huma_hop).LastWriteTime))) { & gawk -f $gawk_script -- $huma_char | Out-File -FilePath $huma_hop -Encoding utf8 -Force }
Link-File -FROM $huma_hop -TO (Join-Path $env:LOCALAPPDATA "nvim-data\lazy\hop.nvim\lua\hop\mappings\zh_huma.lua")

# komorebi
Link-File -FROM (Join-Path $currFolder "windows" "komorebi" "komorebi.json") -TO "$env:USERPROFILE\komorebi.json"
Link-File -FROM (Join-Path $currFolder "windows" "komorebi" "komorebi.bar.json") -TO "$env:USERPROFILE\komorebi.bar.json"
Link-File -FROM (Join-Path $currFolder "windows" "komorebi" "komorebi.ahk") -TO "$env:USERPROFILE\komorebi.ahk"
if (-not (Test-Path (Join-Path -Path $env:USERPROFILE -ChildPath "applications.json"))) { komorebic.exe fetch-asc }

# pynvim
$pynvimInstalled = pip show pynvim 2>$null
if (-not $pynvimInstalled) {
    Write-Host "pynvim not found. Installing..."
    pip install pynvim
} else {
    Write-Host "pynvim is already installed."
}

# im-select
$targetPath = Join-Path -Path $env:USERPROFILE -ChildPath "AppData\Local\Microsoft\WindowsApps"
$filePath = Join-Path -Path $targetPath -ChildPath "im-select.exe"
$downloadUrl = "https://raw.githubusercontent.com/daipeihust/im-select/master/win/out/x86/im-select.exe"  
if (-not (Test-Path $filePath)) {
    Write-Host "im-select.exe 不存在，开始下载..."
    if (-not (Test-Path $targetPath)) { New-Item -ItemType Directory -Path $targetPath | Out-Null }
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $filePath -UseBasicParsing
        Write-Host "下载完成，文件已保存到 $filePath"
    }
    catch {
        Write-Host "下载失败：$_"
    }
}

