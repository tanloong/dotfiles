#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# 替换中文单双引号为英文单双引号
# 删掉单独一行、1到3位数的数字 （页码）
# 删掉 I-1, X-1等页码
# 删掉"♦"、"►"、"•"这些项目列表
# 替换制表符为空格
fn_in="$1"
fn_out="${1/.txt}".tmp
sed -E -e "s/[‘’]/'/g; s/[“”]/\"/g; s/''/\"/g;" "$fn_in" |\
    sed -E 's/—/ - /g' |\
    sed -E 's/^\s*[0-9]{1,3}\s*$//g' |\
    sed -E 's/^\s*[ivxIVX]+\s*-\s*[0-9]+\s*$//g' |\
    sed -E 's/^[□§・■♦►•]\s*//g' |\
    sed -E 's/\t/ /g' |\
    tr -s ' ' > "$fn_out"

mv --force "$fn_out" "$fn_in"
