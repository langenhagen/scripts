#!/bin/bash
# Get the system memory usage via `cgroups`.
# Applicable e.g. inside kubernetes instances.
# Probably not applicable to your laptop.
#
# Usage:
#
#   mem-usage-cgroups.sh [-1|--oneline]
#
# author: andreasl

[[ "$1" =~ ^(-1|--oneline)$ ]] && sep='\t' || sep='\n'

limit=$(cat '/sys/fs/cgroup/memory/memory.limit_in_bytes')
usage=$(cat '/sys/fs/cgroup/memory/memory.usage_in_bytes')
remaining=$((limit - usage))

limit_mb=$(echo "$limit" | awk '{printf "%.2f", $1 / 1024 / 1024}')
usage_mb=$(echo "$usage" | awk '{printf "%.2f", $1 / 1024 / 1024}')
remaining_mb=$(echo "$remaining" | awk '{printf "%.2f", $1 / 1024 / 1024}')

output="Limit: ${limit_mb} MB${sep}Usage: ${usage_mb} MB${sep}Remaining: ${remaining_mb} MB"
echo -e "$output"
