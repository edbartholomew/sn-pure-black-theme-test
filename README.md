# Standard Notes theme starter

https://github.com/christianhans/sn-pure-black-theme
https://standardnotes.com/help/plugins/publishing
Install URL (paste into Standard Notes → Preferences → Plugins):
https://sn-pure-black-theme.edbartholomew.workers.dev/ext.json

Two files matter: `ext.json` (manifest) and `src/theme.css` (your changes).

`dist/theme.css` = upstream Standard Notes Focus theme + `src/theme.css`, built by `./build.sh`.
It's generated, not committed: run the script to test locally; the release job builds it for publishing.

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
2. release-please opens or updates a "Release" PR. Its single commit bumps the version in `package.json`,
   `ext.json` and `CHANGELOG.md`. Nothing else touches the PR, so merge it whenever you like.
3. Merge the PR. release-please tags the merge commit (plain `1.2.3`) and creates the GitHub release.
   The workflow then builds `dist/theme.css`, attaches `theme.zip` (package.json + dist) to the release,
   and deploys `ext.json` and `theme.css` to the Cloudflare Worker.

Hosting: `url` and `latest_url` point at a Cloudflare Worker that serves only those two files
(`wrangler.toml`). It is updated only by the release job, so what's live is always the last release.
Cloudflare clears its cache on deploy and the app revalidates on every load, so a release is live at once.
`download_url` is GitHub's "latest release" link to `theme.zip`, which always resolves to the newest release.

One-time setup:

- Push this folder to a public GitHub repo, then put the owner/repo into `ext.json`'s `identifier` and
  `download_url`, and the repo name into `package.json`'s `name`.
- Cloudflare: in the dashboard, note your account ID and your workers.dev subdomain
  (Workers & Pages → Overview). Create an API token from the "Edit Cloudflare Workers" template.
  Add both to the repo as Actions secrets: `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID`.
  Replace `YOUR-SUBDOMAIN` in `ext.json` and this file with your subdomain. The Worker itself is created
  by the first `wrangler deploy`; nothing needs making in the dashboard.
- Allow the workflow to open pull requests, or release-please fails with
  `GitHub Actions is not permitted to create or approve pull requests`:
   1. Repo → Settings → Actions → General.
   2. Under "Workflow permissions", tick "Allow GitHub Actions to create and approve pull requests" and save.
   3. If the box is greyed out, enable the same setting at the organisation level first.
   4. Re-run the failed workflow from the Actions tab; no new commit is needed.
- `.release-please-manifest.json` holds the current version; keep it in step with `package.json`.
- `release-please-config.json` pins `component` to a fixed name so the tag and PR naming never depend on
  `package.json`'s `name`, and lists `ext.json` under `extra-files` so its version is bumped with the rest.

## Notes

- Put palette changes in the `:root` block of `src/theme.css`; a later `:root` wins over upstream.
- The sidebar rules use native CSS nesting (`&.selected { … }`). No build tool is needed; the browser parses it.
- If some element doesn't pick up your colors, check the Dracula theme source for the
  current variable name — the set changes occasionally between app versions.
