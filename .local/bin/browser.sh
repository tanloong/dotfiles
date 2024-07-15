#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# chromium --enable-features=UseOzonePlatform --ozone-platform=wayland
# chromium
brave "$@"
