#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ -n "$WSL_DISTRO_NAME" ]; then
  first_arg="$1"

  # 检查第一个参数是否以file://开头
  if [[ "$first_arg" == file://* ]]; then
      # 移除file://前缀
      stripped_path="${first_arg#file://}"
      
      # 使用wslpath转换为Windows路径
      windows_path=$(wslpath -w "$stripped_path")
      
      # 构建新的参数列表，第一个参数替换为转换后的路径
      new_args=("$windows_path")
      
      # 添加剩余的参数（从第二个开始）
      shift  # 移除第一个参数
      new_args+=("$@")
      
      # 使用msedge.exe打开，并传递所有参数
      msedge.exe "${new_args[@]}"
  else
      # 如果第一个参数不以file://开头，直接传递所有原始参数
      msedge.exe "$@"
  fi
else
    firefox "$@"
  # chromium --enable-features=UseOzonePlatform --ozone-platform=wayland
  # brave "$@"
  # chromium "$@"
fi
