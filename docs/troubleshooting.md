# Troubleshooting

## The Codex App Does Not Show The Plugin

Make sure you add the repository root as a local marketplace:

```text
/path/to/autodl-remote
```

The root must contain:

```text
.agents/plugins/marketplace.json
```

Do not add:

```text
/path/to/autodl-remote/plugins/autodl-remote
```

After adding the marketplace, fully quit and restart Codex App.

## The CLI Says `.autodl-remote.conf` Is Missing

Bind the current local project to a remote project directory:

```bash
autodl-remote bind --account autodl-gpu --remote /root/autodl-tmp/my-project
```

The config should look like:

```bash
ACCOUNT="autodl-gpu"
REMOTE_ROOT="/root/autodl-tmp/my-project"
```

## Old Config Files

Older experimental versions used fields such as `PROJECT_MODE`, `SSH_TARGET`, and `AUTO_PUSH_BEFORE_RUN`.

The current version does not read that format. Rename the old config and bind again:

```bash
mv .autodl-remote.conf .autodl-remote.conf.old
autodl-remote bind --account autodl-gpu --remote /root/autodl-tmp/my-project
```

## Password Login Hangs Or Fails

For password-based SSH, use prompt auth:

```bash
autodl-remote account add autodl-gpu --target root@host --port 2222 --auth prompt
```

If you need non-interactive password login on macOS, store the password in Keychain:

```bash
autodl-remote account password-save autodl-gpu
```

## Avoid Pulling Large Files

Do not run broad `get` or `sync-down` commands on model, checkpoint, dataset, or output directories unless you really want those files locally.

Prefer remote inspection:

```bash
autodl-remote tree . --depth 2
autodl-remote tail -- logs/train.log
autodl-remote cat -- results/metrics.json
```
