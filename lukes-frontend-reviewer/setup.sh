#!/bin/bash
set -euo pipefail

REPO=${PROFILE_REPO:-osbuild/image-builder-frontend}
PR=${PROFILE_PR:?}

# Clone and check out PR on the host (has gh credentials)
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT
gh repo clone "$REPO" "$TMPDIR/repo"
cd "$TMPDIR/repo"
gh pr checkout "$PR"

# Copy repo to sandbox
sandbox-cp "$TMPDIR/repo/" :~/project/

# Install Node.js, TypeScript LSP, and project dependencies in sandbox
sandbox-ssh "sudo dnf install -y nodejs"
sandbox-ssh "npm install -g typescript typescript-language-server"
sandbox-ssh "cd ~/project && npm ci"
