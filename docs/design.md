# Design

AutoDL Remote is intentionally small.

It provides:

- SSH account management,
- project-to-remote-directory binding,
- remote command execution,
- explicit file upload and download.

It avoids:

- source-of-truth decisions,
- automatic bidirectional sync,
- manifest tracking,
- project skeleton inference,
- remote daemons,
- remote Codex installation.

The intended workflow is:

1. Inspect remote state.
2. Pull only files needed for editing, or edit existing local files.
3. Upload selected local changes.
4. Run commands on the remote host.
5. Inspect logs and small results remotely.

This keeps Codex local while letting remote GPU hosts run heavy jobs.
