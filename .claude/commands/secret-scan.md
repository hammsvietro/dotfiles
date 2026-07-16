---
description: Scan the repo for leaked secrets with gitleaks
---

Sweep the working tree for leaked secrets and report findings.

Run both, using the repo's allowlist config:

```
gitleaks git --no-banner --redact -c ~/dotfiles/.gitleaks.toml ~/dotfiles
gitleaks dir --no-banner --redact -c ~/dotfiles/.gitleaks.toml ~/dotfiles
```

The first scans committed history, the second scans files on disk (including
uncommitted changes). Summarize any findings with file and rule; if both come
back clean, say the tree is clean.
