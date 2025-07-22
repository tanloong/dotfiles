Set-PSReadLineOption -EditMode Vi

Set-Alias -Name c -Value clear
Set-Alias -Name pt -Value python
Set-Alias -Name v -Value nvim
Set-Alias -Name ga -Value lazygit
Set-Alias -Name g -Value git
Set-Alias -Name za -Value sumatrapdf

function Invoke-Item-Dot { Invoke-Item -Path . }
Set-Alias -Name r -Value Invoke-Item-Dot

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
Set-Alias -Name vd -Value deactivate

################################################################################

Set-Alias -Name 可 -Value __zoxide_z
# zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

