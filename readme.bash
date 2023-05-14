#!/usr/bin/env bash

ls modules | while read -r module; do
	name=$(sed -n 's/^name\s*=\s*"\(.*\)"$/\1/p' "modules/$module/wally.toml")
	version=$(sed -n 's/^version\s*=\s*"\(.*\)"$/\1/p' "modules/$module/wally.toml")
	echo "- \`$module = \"$name@$version\"\`"
done
