#!/bin/zsh

# Default example hashes
commit_hashes=("a1b2c3d" "e4f5g6h" "7890abc")

# If arguments are passed, use those instead
if [[ $# -gt 0 ]]; then
  commit_hashes=("$@")
fi

# 1. git show -s: Suppress diff, show metadata only
# 2. --format="%ci %h": Print "YYYY-MM-DD HH:MM:SS +/-TZ" followed by "Hash"
# 3. sort: Sorts the lines. Since ISO dates (YYYY-MM-DD) are sequential, 
#    standard sorting puts them in chronological order.
git show -s --format="%ci %h" "${commit_hashes[@]}" 2>/dev/null | sort
