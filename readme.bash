#!/usr/bin/env bash

printf '> `moonwave build --publish --code modules`\n'

ls modules | while read -r module; do
	name=$(sed -n 's/^name\s*=\s*"\(.*\)"$/\1/p' "modules/$module/wally.toml")
	version=$(sed -n 's/^version\s*=\s*"\(.*\)"$/\1/p' "modules/$module/wally.toml")
	printf '# [%s](https://wally.run/package/%s?version=%s)\n' "$module" "$name" "$version"
	printf '```toml\n%s = "%s@%s"\n```\n' "$module" "$name" "$version"
done
