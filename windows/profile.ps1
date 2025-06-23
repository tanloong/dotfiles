Set-PSReadLineOption -EditMode Vi

Set-Alias -Name c -Value clear
Set-Alias -Name pt -Value python
Set-Alias -Name v -Value nvim
Set-Alias -Name g -Value git

# zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
