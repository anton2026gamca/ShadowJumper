#!/bin/sh
printf '\033c\033]0;%s\a' Shadow Jumper
base_path="$(dirname "$(realpath "$0")")"
"$base_path/shadow_jumper.arm64" "$@"
