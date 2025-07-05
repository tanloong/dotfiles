#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ -n "$WSL_DISTRO_NAME" ]; then
  first_arg="$1"

    # 使用wslpath转换为Windows路径
    windows_path=$(wslpath -w "$first_arg")
      
    # 构建新的参数列表，第一个参数替换为转换后的路径
    new_args=("$windows_path")
      
      # 添加剩余的参数（从第二个开始）
      shift  # 移除第一个参数
      new_args+=("$@")
      
      # 使用msedge.exe打开，并传递所有参数
      /mnt/d/software/Libreoffice/program/soffice.exe "${new_args[@]}"
else
    soffice "$@"
fi
