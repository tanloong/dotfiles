#!/usr/bin/env bash

# 这个脚本将 ~/.local/share/fcitx5/table 下的码表文件转换成 rime 格式，用来从手机的 termux 调用并覆盖到手机的 Android/rime/tigress.dict.yaml，然后在同文输入法进行重新部署，来同步电脑的虎码码表。
# 手机端命令为 ssh usr@ipv4 "fcitx2yaml.sh ~/.local/share/fcitx5/table/huma-word.txt tigress" > /storage/shared/Android/rime/tigress.dict.yaml

# 检查参数数量
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <path_to_huma-word.txt> <name>"
  exit 1
fi

# 读取参数
input_file="$1"
NAME="$2"
DATE=$(date +%Y.%m.%d)

# 确保输入文件存在
if [ ! -f "$input_file" ]; then
  echo "Error: File does not exist."
  exit 1
fi

# 处理数据，替换name和输出文件名
sed -n '/^\[数据\]/,$ {s/ /\t/; p}' "$input_file" |\
  tail -n +2 |\
  sed -e "1i\name: $NAME\nversion: \"$DATE\"\nsort: original\ncolumns:\n  - code\n  - text\nencoder:\n  rules:\n    - length_equal: 2\n      formula: \"AaAbBaBb\"\n    - length_equal: 3\n      formula: \"AaBaCaCb\"\n    - length_in_range: [4, 10]\n      formula: \"AaBaCaZa\"\n..."
