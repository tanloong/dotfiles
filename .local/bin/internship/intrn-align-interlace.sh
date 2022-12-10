#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

fn_zh="$1"
fn_en="$2"
fn_interlaced="${fn_zh//zh/interlaced}"

paste -d '\n' "$fn_zh" "$fn_en" | sed -E '0~2G' > "$fn_interlaced"
nvim "$fn_interlaced"

# 对结果调整时，要把空余出来的位置用 '---' 补全，如

#"""
#第1篇
#CHAPTER 1.1 Definitions
 
#总则
#CHAPTER 1.2 Applicability
#"""

# 改为：

#"""
#第1篇 总则
#CHAPTER 1.1 Definitions
 
#---
#CHAPTER 1.2 Applicability
#"""

