#!/bin/bash

# Usage: ./find_job_commits.sh JOB-1234 JOB-5678 ...
# Or: echo "JOB-1234 JOB-5678" | ./find_job_commits.sh

if [ -t 0 ]; then
  # If no arguments provided and no stdin, show usage
  if [ $# -eq 0 ]; then
    echo "Usage: $0 JOB-#### [JOB-#### ...]"
    echo "Example: $0 JOB-3640 JOB-3731"
    exit 1
  fi
  TICKETS=("$@")
else
  # Read from stdin if available, supporting multiple lines and spaces
  TICKETS=($(cat))
fi

PATTERN=$(printf "|%s" "${TICKETS[@]}")
PATTERN=${PATTERN:1} # remove leading |

echo "Searching for commits related to: ${TICKETS[*]} in branch 'uat'..."
echo "--------------------------------------------------------------------------------"

# git log options:
# -E : Use extended regular expressions for the grep pattern
# --grep="$PATTERN" : search for the pattern in commit messages
# --format="%h %ad %s" : hash, author date, and subject
# --date=short : YYYY-MM-DD format
# --reverse : chronological order (oldest first)
# uat : the branch to search in

git log uat -E --grep="$PATTERN" --format="%h %ad %s" --date=short --reverse
