#!/usr/bin/env bash
# Install one agent as a custom agent into one or more projects.
# Usage: ./install-to-project.sh <agent> <project-dir> [<project-dir> ...]
set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: $0 <agent> <project-dir> [<project-dir> ...]" >&2
  echo "Agents:" >&2
  for f in "$src"/skills/*-agent.md; do
    echo "  $(basename "$f" -agent.md)" >&2
  done
  exit 1
}

[ $# -ge 2 ] || usage

agent="$1"
shift
file="$src/skills/$agent-agent.md"
if [ ! -f "$file" ]; then
  echo "Unknown agent '$agent'" >&2
  usage
fi

status=0
for dest in "$@"; do
  if [ ! -d "$dest" ]; then
    echo "Skipping '$dest': not a directory" >&2
    status=1
    continue
  fi

  mkdir -p "$dest/.github/agents"
  cp -v "$file" "$dest/.github/agents/$agent.agent.md"

  # Remove the legacy location from earlier installs (agents were skills)
  rm -rfv "$dest/.github/skills/$agent"
  rmdir "$dest/.github/skills" 2>/dev/null || true
  echo "Updated $dest"
done

exit $status
