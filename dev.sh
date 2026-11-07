#!/bin/sh
# Serves this folder for ext.dev.json and rebuilds dist/theme.css whenever src/theme.css is saved
cd "$(dirname "$0")"

./build.sh
npx --yes http-server . -p 8000 --cors -c-1 -s &
server=$!
trap 'kill $server' EXIT
echo "Serving http://localhost:8000/ext.dev.json"

last=$(stat -f %m src/theme.css)
while sleep 1; do
	now=$(stat -f %m src/theme.css)
	if [ "$now" != "$last" ]; then
		last=$now
		./build.sh
	fi
done
