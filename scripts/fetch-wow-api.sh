#!/usr/bin/env bash
# Fetch Ketho's WoW API annotations (same source as the ketho.wow-api VS Code extension)
# into .luals/ for command-line LuaLS checks. Bump WOW_API_TAG with the extension.
set -euo pipefail
WOW_API_TAG="${WOW_API_TAG:-0.22.3}"
dest=".luals/vscode-wow-api"
if [ -f "$dest/.tag" ] && [ "$(cat "$dest/.tag")" = "$WOW_API_TAG" ]; then
	exit 0
fi
rm -rf "$dest"
mkdir -p "$dest"
curl -sSL "https://github.com/Ketho/vscode-wow-api/archive/refs/tags/${WOW_API_TAG}.tar.gz" \
	| tar xz -C "$dest" --strip-components=1 --wildcards '*/Annotations/Core'
echo "$WOW_API_TAG" > "$dest/.tag"
