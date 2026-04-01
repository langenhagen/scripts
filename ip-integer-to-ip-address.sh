#!/usr/bin/env bash
# Convert an integer denoting an IP address to a normal IP address.
#
# Usage:
#
#   ip-integer-to-ip-address.sh <INTEGER>
#
# Examples:
#
#   ip-integer-to-ip-address.sh 3232235777  # 192.168.1.1
#
ip_integer="$1"

ip_address="$(printf '%d.%d.%d.%d' \
    $((ip_integer >> 24 & 0xFF)) \
    $((ip_integer >> 16 & 0xFF)) \
    $((ip_integer >> 8 & 0xFF)) \
    $((ip_integer & 0xFF)))"

echo "$ip_address"
