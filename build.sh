#!/bin/sh
set -e
cd "$(dirname "$0")"

URL="https://raw.githubusercontent.com/standardnotes/app/main/packages/web/src/components/assets/org.standardnotes.theme-focus/index.css"

mkdir -p dist
# Fetched once and reused by the dev loop; delete dist/upstream.css to refresh it
[ -f dist/upstream.css ] || curl -fsSL "$URL" -o dist/upstream.css
{ cat dist/upstream.css; echo; cat src/theme.css; } > dist/theme.css
echo "Built theme.css"
