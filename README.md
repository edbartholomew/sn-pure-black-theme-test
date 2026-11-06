# Standard Notes theme starter

https://github.com/christianhans/sn-pure-black-theme
https://standardnotes.com/help/plugins/publishing
Three files matter: `ext.json` (manifest), `src/theme.css` (your changes) and `dist/theme.css` (generated).

`dist/theme.css` = upstream Standard Notes Focus theme + `src/theme.css`, built by `./build.sh`.
Edit `src/theme.css`, never `dist/theme.css` directly, then re-run the script.

## Test locally

1. From this folder:
   ```
   npx http-server . -p 8000 --cors -c-1
   ```
2. Standard Notes desktop → Preferences → General → Advanced → Install custom plugin.
3. Paste `http://localhost:8000/ext.json`.
4. Activate "My Theme" from the Appearance menu.
5. After editing `src/theme.css`, run `npm run build` (or `./build.sh`), then toggle the theme off and on to reload it.

Fast iteration: View → Toggle Developer Tools, select `:root` in Elements, and edit
`--sn-stylekit-*` values live. Copy the ones you like back into `src/theme.css`.

## Release

Releases are driven by [release-please](https://github.com/googleapis/release-please-action)
from `.github/workflows/release.yml`.

1. Commit to `main` with a conventional prefix: `fix:` (patch), `feat:` (minor), `feat!:` (major).
   Other prefixes such as `chore:` don't trigger a release.
2. release-please opens or updates a "Release" PR that bumps `package.json` and `CHANGELOG.md`.
   The workflow then writes the repo owner/name and the version into `ext.json`, rebuilds `dist/theme.css`,
   and pushes both onto the PR.
3. Merge the PR. release-please tags the merge commit (plain `1.2.3`) and creates the GitHub release.
   The workflow purges jsDelivr's cache for `ext.json` so the app sees the new version.

One-time setup:

- Push this folder to a public GitHub repo. The workflow fills in the owner/repo in `ext.json`'s
  identifier and URLs on the first release PR, so the `username` placeholder can stay.
- Repo Settings → Actions → General → enable "Allow GitHub Actions to create and approve pull requests".
- `.release-please-manifest.json` holds the current version; keep it in step with `package.json`.

## Notes

- Put palette changes in the `:root` block of `src/theme.css`; a later `:root` wins over upstream.
- The sidebar rules use native CSS nesting (`&.selected { … }`). No build tool is needed; the browser parses it.
- If some element doesn't pick up your colors, check the Dracula theme source for the
  current variable name — the set changes occasionally between app versions.
