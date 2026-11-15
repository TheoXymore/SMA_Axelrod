#!/bin/sh
printf '\033c\033]0;%s\a' SMA_Axelrod
base_path="$(dirname "$(realpath "$0")")"
"$base_path/SMA_Axelrod.x86_64" "$@"
