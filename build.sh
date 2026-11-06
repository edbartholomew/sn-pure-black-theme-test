#!/bin/sh
set -e
cd "$(dirname "$0")"

URL="https://raw.githubusercontent.com/standardnotes/app/main/packages/web/src/components/assets/org.standardnotes.theme-focus/index.css"

mkdir -p dist
{ curl -fsSL "$URL"; echo; cat src/theme.css; } > dist/theme.css
echo "Built theme.css"