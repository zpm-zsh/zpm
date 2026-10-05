---
name: release
description: Pick the next zpm version, update the changelog, merge next into main, tag, and publish a GitHub release. Use when asked to release, bump the version, or cut a hotfix.
disable-model-invocation: true
argument-hint: "[major|minor|patch]"
---

# Releasing zpm

Pushing to `main`, tagging, and `gh release create` are public and hard to undo. Show the
maintainer the version, the notes, and the commands, then wait for confirmation.

## Versioning

Tags are annotated `vMAJOR.MINOR.PATCH` and point at the release merge commit on `main`.

| Bump | When |
|---|---|
| MAJOR | A user must change their config or do something by hand: a plugin-spec syntax, tag, type or `zpm` subcommand is removed or renamed; default install/cache paths move; the minimum zsh version goes up |
| MINOR | Backwards-compatible features: a new tag, type, subcommand or option; a new workaround for a third-party plugin; visible behaviour or performance changes |
| PATCH | Bug fixes only, with no new features and no breaking changes |

Docs-, test- and CI-only changes do not need a release on their own. They go out with the next
one.

When changes are mixed, the highest bump wins. If unsure between two levels, ask.

## 1. Preconditions

```bash
git fetch origin --tags
git switch next && git pull --ff-only
git log --oneline origin/next..origin/main   # must be empty; otherwise merge main into next first
git describe --tags --abbrev=0 origin/main   # last release, e.g. v6.1.0
```

## 2. Collect changes

```bash
LAST=$(git describe --tags --abbrev=0 origin/main)
git log --no-merges --format='%h %s (%an)' $LAST..origin/next
gh pr list --state merged --base next --search "merged:>$(git log -1 --format=%cs $LAST)"
gh pr list --state merged --base main --search "merged:>$(git log -1 --format=%cs $LAST)"
```

Compare the commits with the `- next` section of README `## Changelog`. Every user-visible
change needs a line there, with links to the PR and the external author's profile. Add any
missing lines. Classify each line as major, minor or patch, and propose the version. Use
`$ARGUMENTS` only if the maintainer gave a level and it does not understate the changes.

## 3. Verify

- `make test` locally: read the `PASS/FAIL` line, because the exit code is always 0.
- The latest CI run on `next`: there must be no `FAIL:` lines that the previous release did not
  have, on either OS (`gh run view <id> --log | grep -E 'PASS=|FAIL:'`).

## 4. Changelog commit (on `next`)

Rename `- next` to `- X.Y` for a minor or major release, or to `- X.Y.Z` for a patch, keeping
the existing list style.

```bash
git commit -am "docs(changelog): set release X.Y.Z notes"
```

## 5. Merge, tag, publish (after confirmation)

```bash
git switch main && git pull --ff-only
git merge --no-ff next -m "Merge branch 'next' into main (release vX.Y.Z)"
make test
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin main vX.Y.Z
gh release create vX.Y.Z --title vX.Y.Z --latest --notes-file <notes.md>
```

The notes start with `### Release vX.Y.Z`, followed by the changelog lines for this version.

Then fast-forward `next`:

```bash
git switch next && git merge --ff-only main && git push origin next
```

## Hotfix (patch from `main`)

Use this when a fix is already merged into `main` but `next` holds unreleased features.

1. On `main`, add `- X.Y.Z` to the Changelog with the fix lines. Commit with
   `docs(changelog): set release X.Y.Z notes`.
2. Tag `vX.Y.Z` on that commit, push, and run `gh release create` as above.
3. Merge `main` into `next` with `--no-ff`. When resolving the Changelog conflict, keep `- next`
   above `- X.Y.Z`.

## After the release

- Comment on the issues the release fixes, saying `Released in vX.Y.Z`.
