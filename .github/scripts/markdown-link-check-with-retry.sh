#!/bin/bash -e

# this script helps to reduce sporadic link check failures by retrying at a file-by-file level

retry_count=3
config="$(dirname "$0")/markdown-link-check-config.json"

for file in "$@"; do
  for i in $(seq 1 $retry_count); do
    if npx --no -- markdown-link-check --quiet --progress --config "$config" "$file"; then
      break
    elif [[ $i -eq $retry_count ]]; then
      exit 1
    fi
    sleep 5
  done
done
