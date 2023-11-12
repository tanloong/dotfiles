#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

file_path="$1"
N="$2"
bsname=$(basename "$file_path")

split --numeric-suffixes=1 --additional-suffix='.txt' -l $(($(wc -l < "$file_path") / "$N")) "$file_path" "$bsname"
