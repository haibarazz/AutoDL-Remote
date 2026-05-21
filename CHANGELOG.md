# Changelog

## 0.7.0

- Added project-local fleets for grouping multiple AutoDL/SSH accounts under one experiment workspace.
- Added `fleet create`, `fleet add`, `fleet list`, and `fleet status`.
- Added read-only `dashboard` generation for single-machine and fleet views.
- Added `dashboard --watch <seconds> --lines <n>` so the page can refresh itself and display recent remote run logs without Codex copying logs into chat.
- Added run-oriented commands: `run submit`, `run list`, `run status`, `run tail`, and `run note`.
- Added run metadata fields for model, tags, stage, purpose, outputs, account, and remote root.
- Added `--account` and `--remote` overrides for `exec`, `put`, `get`, `tree`, `ls`, `cat`, and `tail` so one local project can operate multiple remote machines.
- Fixed detached remote execution so long-running jobs detach from the SSH session immediately.
- Fixed stdin handling during remote temp-directory creation so `exec --script` and `exec --stdin` no longer upload empty scripts.
- Moved SSH ControlMaster sockets to a short `/tmp` path by default to avoid OpenSSH `ControlPath too long` failures on macOS temporary homes.

## 0.6.3

- Strengthened the Codex skill rules so AutoDL/SSH work defaults to `autodl-remote` instead of raw `ssh`/`expect` scripts.
- Instructed Codex to use `exec --script` or `exec --stdin` for complex remote checks and to avoid printing credentials when bypassing the plugin.

## 0.6.2

- Added `autodl-remote --version`, `autodl-remote -V`, and `autodl-remote version`.

## 0.6.1

- Fixed keychain/expect argument forwarding for SSH password prompts.
- Reused SSH ControlMaster settings for `scp` fallback paths.
- Improved `exec --stdin` and `exec --script` upload behavior.
- Refined dangerous command protection to allow concrete file/subdirectory deletion while still blocking root/project-root deletion and raw shutdown-style commands.

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
