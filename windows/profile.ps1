Set-PSReadLineOption -EditMode Vi

if (-not $env:EDITOR)       { $env:EDITOR       = 'nvim' }
if (-not $env:PDFVIEWER)    { $env:PDFVIEWER    = 'SumatraPDF' }
if (-not $env:FILE_MANAGER) { $env:FILE_MANAGER = 'lf' }

#################################### alias #####################################

Set-Alias -Name c -Value clear
Set-Alias -Name pt -Value python
Set-Alias -Name v -Value nvim
Set-Alias -Name ga -Value lazygit
Set-Alias -Name g -Value git
Set-Alias -Name za -Value sumatrapdf

function Copy-CurrentPathToClipboard {
    try {
        $currentPath = Get-Location | Select-Object -ExpandProperty Path
        $currentPath | Set-Clipboard
        Write-Output $currentPath
    }
    catch {
        Write-Error "Error: $_"
    }
}
Set-Alias -Name pwdc -Value Copy-CurrentPathToClipboard

function New-DirectoryAndSetLocation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path
    )

    try {
        $createdDir = New-Item -ItemType Directory -Force -Path $Path
        Set-Location -Path $createdDir.FullName
    }
    catch {
        Write-Error "Error: $_"
    }
}
Set-Alias -Name mcd -Value New-DirectoryAndSetLocation


Set-PSReadLineOption -Colors @{
    Command = 'Green'           # 命令（如 Get-Process）
}

Set-PSReadLineKeyHandler -Key Ctrl+W -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Ctrl+D -Function DeleteCharOrExit

################################################################################

function Activate-Venv {
    $cwd = (Get-Location).Path
    $root = $cwd.Drive.Root
    $venvPath = $null

    # 递归向上查找.venv目录
    while ($true) {
        $scriptsPath = Join-Path $cwd ".venv\Scripts"

        if (Test-Path $scriptsPath) {
            $venvPath = (Get-Item $scriptsPath).FullName
            break
        }

        $cwd = (Split-Path $cwd -Parent)
        if ([string]::IsNullOrEmpty($cwd) -or $cwd -eq $root) { break }
    }

    if ($venvPath) {
        $activatePath = Join-Path $venvPath "Activate.ps1"
        if (Test-Path $activatePath) {
            & $activatePath
        } else {
            Write-Host "找到.venv目录: $venvPath，但未找到激活脚本"
        }
    } else {
        Write-Host "当前盘符下未找到.venv目录"
    }
}

Set-Alias -Name va -Value Activate-Venv
Set-Alias -Name 以来 -Value Activate-Venv
Set-Alias -Name vd -Value deactivate
Set-Alias -Name 这里 -Value deactivate

##################################### fzf ######################################

# 让 powershell 默认输出 utf8 编码，不然 fzf 会乱码
# Reference: 
  # https://reine-ishyanami.github.io/blogs/ops/powershellUtf8.html
  # https://github.com/junegunn/fzf/pull/3951
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Invoke-FzfWith {
    param(
        [Parameter(Mandatory)]
        [string]$Opener,
        [string]$Query = ''
    )

    $file = fzf --reverse --query $Query
    if (-not [string]::IsNullOrWhiteSpace($file)) {
        $file = Resolve-Path $file -ErrorAction Stop
        $dir  = Split-Path $file -Parent
        switch ($Opener.ToLower()) {
            'cd' { Set-Location $dir }
            default {
                & $Opener $file
            }
        }
    }
}

function fv { Invoke-FzfWith $env:EDITOR }               # 编辑
function fcd { Invoke-FzfWith 'cd' }                     # 进入目录
function fz { Invoke-FzfWith $env:PDFVIEWER }            # 看 pdf

function mm {
    param(
        [Parameter(Mandatory)]
        [string]$Query = ''
    )
    Push-Location D:\docx\memorandum
    Invoke-FzfWith $env:EDITOR $Query
    Pop-Location
}

function nq {
    param(
        [Parameter(Mandatory)]
        [string]$Pattern
    )
    $tempFile = New-TemporaryFile
    $qflist = rg --vimgrep --smart-case $Pattern
    if ($qflist) {
        $qflist | Out-File $tempFile -Encoding UTF8
        nvim -q $tempFile
    }
}

##################################### yazi #####################################

function Invoke-Yazi {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}
Set-Alias -Name r -Value Invoke-Yazi
function Invoke-Item-Dot { Invoke-Item -Path . }
Set-Alias -Name s -Value Invoke-Item-Dot

##################################### prompt ###################################

function prompt {
    # Get the last component of the current working directory
    $drv  = (Get-Location).Drive.Name
    $leaf = Split-Path -Leaf $pwd

    $green  = "`e[92m"
    $blue = "`e[38;2;0;95;255m"
    # $blue = "`e[38;2;31;111;136m"
    $reset  = "`e[0m"

    "${green}${drv}${reset}:${blue}${leaf}${reset}`$ "
}


<#
.SYNOPSIS
  把文件版本号自动 +1 或初始化为 _v2
.EXAMPLE
  Bump-Script .\foo_v3.txt .\bar.log
  # 结果：foo_v4.txt, bar_v2.log
#>
function Bump-Script {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromRemainingArguments)]
        [ValidateScript({
            if (-not (Test-Path $_ -PathType Leaf)) {
                throw "'$_' 不是文件"
            }
            $true
        })]
        [string[]]$Path
    )

    foreach ($item in $Path) {
        $file = Get-Item $item
        $name = $file.BaseName          # 不含扩展名
        $ext  = $file.Extension         # 含点

        if ($name -match '_v(\d+)$') {
            $current = [int]$Matches[1]
            $newName = $name -replace '_v\d+$', "_v$($current + 1)"
        } else {
            $newName = "${name}_v2"
        }

        $newFull = Join-Path $file.Directory.FullName ($newName + $ext)

        if (Test-Path $newFull) {
            Write-Warning "已存在 $newFull，跳过 $($file.Name)"
            continue
        }

        Rename-Item -LiteralPath $file.FullName -NewName $newFull
        Write-Host "重命名：$($file.Name)  -->  $(Split-Path $newFull -Leaf)"
    }
}


#################################### zoxide ####################################

Set-Alias -Name 可 -Value __zoxide_z


$Env:GIT_EDITOR = "nvim"

# zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

