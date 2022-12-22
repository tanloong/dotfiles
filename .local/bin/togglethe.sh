#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ -n "$(pgrep "$1")" ]; then
    killall "$1"
else
    "$@"
fi
