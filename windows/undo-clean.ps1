<#
.SYNOPSIS
清理超过指定天数未修改的Vim撤销文件

.DESCRIPTION
该脚本会删除指定目录中超过设定天数未修改的Vim撤销文件，并将删除记录保存到日志文件中

.PARAMETER Threshold
可选参数，指定保留天数阈值，超过此天数的文件将被删除，默认30天

.PARAMETER UndoPath
可选参数，指定Vim撤销文件存储目录，默认是$HOME/.local/state/nvim/undo/

.EXAMPLE
.\undo-clean.ps1
使用默认参数清理撤销文件

.EXAMPLE
.\undo-clean.ps1 15
将阈值设为15天，使用默认路径清理

.EXAMPLE
.\undo-clean.ps1 20 "C:\Users\user\.vim\undo"
将阈值设为20天，清理指定路径的撤销文件
#>

param(
    [Parameter(Position=0)]
    [ValidatePattern('^\d+$')]
    [string]$Threshold = "30",
    
    [Parameter(Position=1)]
    [string]$UndoPath = "$env:LOCALAPPDATA/nvim-data/undo/"
)

$ErrorActionPreference = "Stop"

# 验证撤销文件目录是否存在
if (-not (Test-Path -Path $UndoPath -PathType Container)) {
    Write-Error "目录不存在: $UndoPath"
    exit 65
}

Write-Host "THRESHOLD=$Threshold"
Write-Host "UNDO_PATH=$UndoPath"

# 计算截止时间（当前时间减去指定天数）
$cutoffDate = (Get-Date).AddDays(-[int]$Threshold)

# 查找并删除超过阈值的文件，同时记录日志
Get-ChildItem -Path $UndoPath -File | 
    Where-Object { $_.LastWriteTime -lt $cutoffDate } |
    ForEach-Object {
        $_.FullName
        Remove-Item -Path $_.FullName -Force
    }
