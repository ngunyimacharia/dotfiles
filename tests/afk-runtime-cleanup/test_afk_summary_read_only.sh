#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
summary_file="$repo_root/private_dot_config/opencode/command/afk-summary.md"

require_pattern() {
  pattern=$1
  description=$2

  if ! grep -Eiq "$pattern" "$summary_file"; then
    printf '%s\n' "Missing expected summary guard: $description" >&2
    exit 1
  fi
}

forbid_pattern() {
  pattern=$1
  description=$2

  if grep -Eiq "$pattern" "$summary_file"; then
    printf '%s\n' "Found forbidden cleanup language: $description" >&2
    exit 1
  fi
}

require_pattern 'strictly informational' 'informational-only statement'
require_pattern 'strictly read-only' 'read-only statement'
require_pattern 'do not change ticket statuses' 'ticket status guard'
require_pattern 'do not commit or stage any changes' 'no staging or commits'
require_pattern 'do not clean up tmux resources or delete opencode sessions' 'tmux and session cleanup guard'
require_pattern 'do not run broad process cleanup or terminate AFK helper processes' 'broad process cleanup guard'
require_pattern 'report only; take no action beyond reading and summarizing' 'report-only constraint'

forbid_pattern '/afk-cleanup' 'cleanup command delegation'
forbid_pattern 'ask the user to confirm cleanup' 'cleanup confirmation request'
forbid_pattern 'delegate to any cleanup command' 'cleanup delegation'
forbid_pattern 'execute deletion' 'destructive execution language'
forbid_pattern 'delete terminal issue files' 'issue deletion language'
forbid_pattern 'delete matching afk log files' 'log deletion language'
forbid_pattern 'delete feature directories' 'directory deletion language'

printf '%s\n' "afk-summary read-only guard passed"
