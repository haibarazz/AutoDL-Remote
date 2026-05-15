# Changelog

## 0.6.0

- Added `autodl-remote shutdown` with shutdown/poweroff/halt fallback and SSH disconnect-aware success handling.
- Added detached job registry commands: `job list`, `job status <name>`, and `job tail <name>`.
- Added `exec --script <local_script>` and `exec --stdin -- <command>` for complex multi-line remote commands.
- Added `put-run <local-path>... -- <command>` to upload selected local paths before running a remote command.
- Added `model-dir [--mkdir]` and automatic local `.autodl-remote/CONVENTIONS.md` creation for project-level remote conventions.

## 0.5.0

Initial public package.

- Added Bash-only `autodl-remote` CLI.
- Added Codex plugin metadata and skill instructions.
- Added repo-local marketplace manifest.
- Added SSH account management.
- Added explicit `put`, `get`, `sync-up`, and `sync-down` file operations.
- Added remote `exec`, `tree`, `ls`, `cat`, `tail`, and `shell` commands.
- Removed earlier source-of-truth modes, manifest tracking, and automatic sync behavior.
