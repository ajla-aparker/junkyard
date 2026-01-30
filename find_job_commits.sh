#!/bin/bash

# Usage: ./find_job_commits.sh BRANCH JOB-1234 JOB-5678 ...
# Or: echo "JOB-1234 JOB-5678" | ./find_job_commits.sh BRANCH

if [ -t 0 ]; then
  # If no arguments provided and no stdin, show usage
  if [ $# -lt 2 ]; then
    echo "Usage: $0 BRANCH JOB-#### [JOB-#### ...]"
    echo "Example: $0 main JOB-3640 JOB-3731"
    exit 1
  fi
  BRANCH=$1
  shift
  TICKETS=("$@")
else
  # Read from stdin if available, supporting multiple lines and spaces
  if [ $# -lt 1 ]; then
    echo "Usage: echo \"JOB-####\" | $0 BRANCH"
    exit 1
  fi
  BRANCH=$1
  shift
  TICKETS=($(cat))
fi

PATTERN=$(printf "|%s" "${TICKETS[@]}")
PATTERN=${PATTERN:1} # remove leading |

echo "Searching for commits related to: ${TICKETS[*]} in branch '$BRANCH'..."
echo "--------------------------------------------------------------------------------"

# git log options:
# --no-pager : send output directly to the terminal
# -E : Use extended regular expressions for the grep pattern
# --grep="$PATTERN" : search for the pattern in commit messages
# --format="%h %ad %s" : hash, author date, and subject
# --date=short : YYYY-MM-DD format
# --reverse : chronological order (oldest first)

git --no-pager log "$BRANCH" -E --grep="$PATTERN" --format="%h %ad %s" --date=short --reverse | cat
