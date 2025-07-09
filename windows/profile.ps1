Set-PSReadLineOption -EditMode Vi

Set-Alias -Name c -Value clear
Set-Alias -Name pt -Value python
Set-Alias -Name v -Value nvim
Set-Alias -Name g -Value git

Set-PSReadLineOption -Colors @{
    Command = 'Green'           # 命令（如 Get-Process）
    Parameter = 'Magenta'      # 参数（如 -Name）
    String = 'Yellow'          # 字符串
    Number = 'Blue'            # 数字
    Operator = 'Gray'      # 操作符（如 |、&&）
    Variable = 'DarkYellow'    # 变量（如 $var）
    Type = 'Cyan'             # 类型（如 [int]）
    Comment = 'DarkGray'      # 注释
}

Set-PSReadLineKeyHandler -Key Ctrl+W -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Ctrl+D -Function DeleteCharOrExit

# zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

