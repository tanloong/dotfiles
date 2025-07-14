Set-PSReadLineOption -EditMode Vi

Set-Alias -Name c -Value clear
Set-Alias -Name pt -Value python
Set-Alias -Name v -Value nvim
Set-Alias -Name g -Value git

Set-PSReadLineOption -Colors @{
    Command = 'Green'           # 命令（如 Get-Process）
}

Set-PSReadLineKeyHandler -Key Ctrl+W -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Ctrl+D -Function DeleteCharOrExit

# zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

