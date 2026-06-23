#!/usr/bin/env bash
# Publishes this package to https://github.com/vishalsharma-hovr/hovr_native_platform_view
#
# Prerequisites:
#   - GitHub CLI: brew install gh && gh auth login
#   - Or create an empty public repo manually, then set REMOTE_URL below.
#
# After publishing, update the host app pubspec.yaml:
#   hovr_native_platform_view:
#     git:
#       url: https://github.com/vishalsharma-hovr/hovr_native_platform_view.git
#       ref: v0.1.0
# Then remove packages/hovr_native_platform_view from the monorepo.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="${1:-v0.1.0}"
GITHUB_OWNER="${GITHUB_OWNER:-vishalsharma-hovr}"
REPO_NAME="${REPO_NAME:-hovr_native_platform_view}"
REMOTE_URL="${REMOTE_URL:-https://github.com/${GITHUB_OWNER}/${REPO_NAME}.git}"
WORK_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

echo "Copying package to $WORK_DIR ..."
rsync -a --exclude '.dart_tool' --exclude 'build' --exclude 'example/build' "$ROOT/" "$WORK_DIR/"

cd "$WORK_DIR"
git init -b main
git add -A
git commit -m "Release $VERSION"

git tag "$VERSION"

if command -v gh >/dev/null 2>&1; then
  if ! gh auth status >/dev/null 2>&1; then
    echo "GitHub CLI is not authenticated. Run one of:"
    echo "  gh auth login"
    echo "  export GH_TOKEN=<your-github-personal-access-token>"
    exit 1
  fi
  if ! gh repo view "${GITHUB_OWNER}/${REPO_NAME}" >/dev/null 2>&1; then
    echo "Creating GitHub repository ${GITHUB_OWNER}/${REPO_NAME} ..."
    gh repo create "${GITHUB_OWNER}/${REPO_NAME}" --public --source=. --remote=origin --push
  else
    git remote add origin "$REMOTE_URL" 2>/dev/null || git remote set-url origin "$REMOTE_URL"
    git push -u origin main
    git push origin "$VERSION"
  fi
  echo "Published $VERSION to $REMOTE_URL"
else
  echo "gh CLI not found. Install with: brew install gh && gh auth login"
  echo "Local git repo prepared in $WORK_DIR"
  echo "Create https://github.com/new (owner: ${GITHUB_OWNER}, name: ${REPO_NAME}), then run:"
  echo "  cd $WORK_DIR"
  echo "  git remote add origin $REMOTE_URL"
  echo "  git push -u origin main"
  echo "  git push origin $VERSION"
  trap - EXIT
fi
