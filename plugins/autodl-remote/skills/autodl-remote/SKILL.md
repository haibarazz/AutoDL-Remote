---
name: autodl-remote
description: Use when Codex should control an AutoDL or SSH server from the local machine, run remote commands, and explicitly upload or download selected files.
---

# AutoDL Remote

Use this skill when the user wants Codex to work locally while controlling AutoDL through SSH.

## Operating Model

- The plugin is a thin SSH tool layer.
- Do not decide that local or remote is the source of truth globally.
- Do not use `local-main`, `remote-main`, manifests, sparse-cache modes, or automatic code ownership rules.
- Codex decides the smallest useful action each time: inspect, upload, download, run, or tail logs.
- Do not download LLM weights, checkpoints, datasets, or large outputs unless the user explicitly asks.
- Prefer reading remote files/logs in place with `cat`, `tail`, `ls`, and `tree`.

## Setup

Use an existing account or create one:

```bash
autodl-remote account list
autodl-remote account add autodl-gpu --target root@host --port 2222 --auth prompt
autodl-remote account use autodl-gpu
```

Bind the current local directory to the concrete remote directory the user wants:

```bash
autodl-remote bind --account autodl-gpu --remote /root/autodl-tmp/my-project
```

The project config should only contain `ACCOUNT` and `REMOTE_ROOT`.

## Core Commands

```bash
autodl-remote doctor
autodl-remote tree . --depth 2
autodl-remote ls .
autodl-remote cat -- README.md
autodl-remote tail -- logs/train.log

autodl-remote put ./train.py train.py
autodl-remote get outputs/result.csv ./outputs/result.csv
autodl-remote sync-up ./src src
autodl-remote sync-down logs/train.log ./logs/train.log

autodl-remote exec -- pwd
autodl-remote exec -- python train.py
autodl-remote exec --detach --name train -- python train.py
```

## Behavior Rules

- Before editing remote-existing code, inspect with `tree`, `ls`, `cat`, or `get` only the needed files.
- Before running remote code that depends on local edits, explicitly upload the edited files or directories with `put` or `sync-up`.
- After remote execution, inspect logs remotely first; pull only small result files when useful.
- If both local and remote have similar files, do not assume one should overwrite the other. Compare or inspect first, then choose `put` or `get`.
- Use `exec --detach` for long training jobs and then `tail` the log path.
- Treat broad destructive commands as dangerous; require explicit user approval before using `--allow-dangerous`.
