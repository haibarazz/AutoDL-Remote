# AutoDL Remote

AutoDL Remote is a thin SSH tool layer for Codex.

It does not decide whether local code or remote code is the source of truth. Codex and the user decide what to inspect, upload, download, and run.

The remote server does not need Codex, Python, a proxy, an OpenAI login, or a daemon.

## Model

The plugin has three primitives:

- SSH account management
- Remote command execution
- File upload/download

Global account config lives in:

```bash
~/.autodl-remote/accounts/
```

Project binding lives in the project root:

```bash
.autodl-remote.conf
```

The project file only stores:

```bash
ACCOUNT="autodl-gpu"
REMOTE_ROOT="/root/autodl-tmp/my-project"
```

Passwords are never written to project files.

## Quick Start

Create or choose an account:

```bash
autodl-remote account add autodl-gpu \
  --target root@connect.example.com \
  --port 2222 \
  --auth prompt \
  --default-remote /root/autodl-tmp

autodl-remote account use autodl-gpu
autodl-remote account list
```

Bind the current local directory to a concrete remote directory:

```bash
autodl-remote bind --remote /root/autodl-tmp/my-project
```

Inspect and run:

```bash
autodl-remote doctor
autodl-remote model-dir
autodl-remote tree . --depth 2
autodl-remote exec -- pwd
autodl-remote exec -- python train.py
autodl-remote exec --detach --name train -- python train.py
autodl-remote job status train
autodl-remote job tail train
```

Move files only when needed:

```bash
autodl-remote put ./train.py train.py
autodl-remote put-run ./train.py -- python train.py
autodl-remote get outputs/result.csv ./outputs/result.csv
autodl-remote sync-up ./src src
autodl-remote sync-down logs/train.log ./logs/train.log
```

Run complex local scripts without shell quoting problems:

```bash
autodl-remote exec --script scripts/remote_check.sh
cat scripts/remote_check.sh | autodl-remote exec --stdin -- bash
```

Shutdown the remote machine after a run:

```bash
autodl-remote shutdown
```

## Accounts

List accounts:

```bash
autodl-remote account list
```

Show an account without exposing passwords:

```bash
autodl-remote account show autodl-gpu
```

Set the default account:

```bash
autodl-remote account use autodl-gpu
```

Password login is the default for AutoDL:

```bash
autodl-remote account add autodl-gpu --target root@host --port 2222 --auth prompt
```

SSH key login:

```bash
autodl-remote account add gpu-key --target root@host --port 22 --key ~/.ssh/id_rsa --auth ssh-key
```

Optional macOS Keychain password storage:

```bash
autodl-remote account password-save autodl-gpu
```

When an account uses `AUTH="keychain"`, the CLI retrieves the password from macOS Keychain and drives password prompts with `expect`.

## Commands

```bash
autodl-remote account add <name> [--target root@host] [--port 22] [--key path] [--auth prompt|keychain|ssh-key] [--default-remote path]
autodl-remote account list
autodl-remote account show <name>
autodl-remote account use <name>
autodl-remote account test [name]
autodl-remote account password-save <name>
autodl-remote account password-delete <name>

autodl-remote bind [--account name] --remote /remote/project/root
autodl-remote doctor
autodl-remote model-dir [--mkdir]

autodl-remote exec [--detach] [--cwd path] [--name name] [--script local_script] [--stdin] -- <command>
autodl-remote put-run <local-path>... -- <command>
autodl-remote put <local-path> [remote-path]
autodl-remote get <remote-path> [local-path]
autodl-remote sync-up <local-path> [remote-path]
autodl-remote sync-down <remote-path> [local-path]
autodl-remote tree [remote-path] [--depth 3] [--limit 500]
autodl-remote ls [remote-path]
autodl-remote cat [--lines 200] -- <remote-path>
autodl-remote tail [--lines 120] [--follow] -- <remote-path>
autodl-remote job list
autodl-remote job status <name>
autodl-remote job tail [--lines 120] [--follow] <name>
autodl-remote shutdown [--wait seconds]
autodl-remote shell
autodl-remote history
```

## Design Rules

- No `local-main` or `remote-main`.
- No manifest.
- No automatic code ownership decision.
- No automatic pull before edit.
- No automatic push before run.
- Use `put/get/sync-up/sync-down` explicitly.
- Keep large models, datasets, checkpoints, and training outputs on AutoDL unless the user explicitly pulls them.
- Use `exec --script` or `exec --stdin` for multi-line shell/Python snippets.
- Use `job status` and `job tail` for detached training jobs created with `exec --detach --name`.
- Use `shutdown` instead of guessing provider-specific poweroff commands.
