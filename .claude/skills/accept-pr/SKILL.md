---
name: accept-pr
description: Review, fix up, merge and close out a pull request to zpm-zsh/zpm. Use when asked to check, accept, or merge a PR.
disable-model-invocation: true
argument-hint: <pr-number>
---

# Accepting a PR

Steps that touch GitHub (pushing to the contributor's branch, approving CI, merging, commenting)
need the maintainer's go-ahead in this session. Ask once and list all of them together.

## 1. Gather

```bash
gh pr view $ARGUMENTS --json title,body,author,baseRefName,headRefName,headRepositoryOwner,maintainerCanModify,closingIssuesReferences,files
gh pr diff $ARGUMENTS
gh issue view <linked-issue> --comments
```

- **Base branch:** fixes may target `main`. Features, new tags/types/commands and refactors go
  to `next`. If the base is wrong, ask the contributor, or use `gh pr edit --base next`.
- Any change under `.github/` in a PR from a fork is a red flag: it will run with CI secrets
  once approved. Read it before anything else.

## 2. Understand the bug or feature

- Find the root cause in the issue or the code (`git log -S`, `git blame` of the lines the PR
  changes). The fix must address the root cause, not mask a symptom.
- For a regression, name the commit that introduced it. You will need it for the issue comment.

## 3. Review

Run `/code-review $ARGUMENTS`, then check zpm specifics by hand:

- **Portability:** no GNU-only flags; works with BSD (macOS) and busybox userland. See
  CLAUDE.md → Portability.
- **Startup cost:** nothing new forks on the warm path. `lib/init.zsh` and the generated caches
  run on every shell start.
- **Scope leaks:** plugin/core code doesn't leak options or locals into the user's shell
  (`emulate -L zsh`, anonymous-function scope).
- **Cache:** changes that affect generated cache files keep the cold path and the warm path
  equivalent (see the `cache-*` integration tests).
- **PMSPEC**, the `@zpm-` naming convention, one function per file, and new functions added to
  the autoload list in `lib/init.zsh`.
- **Tests:** new behaviour has a test in `tests/unit` or `tests/integration`, and no assertion
  was weakened or removed.
- **Changelog:** a line under `- next` in README `## Changelog`, with links to the PR and the
  author's profile.

## 4. CI

- A PR from a fork shows `action_required`. Approve the run only after step 1:
  `gh api -X POST repos/zpm-zsh/zpm/actions/runs/<id>/approve`.
- Both `ubuntu-latest` and `macos-latest` must pass. To see which assertions failed:
  `gh run view <run> --log | grep -E 'PASS=|FAIL:' | cut -f1,3-`.

## 5. Fix up or request changes

- If the fixes are small and `maintainerCanModify` is true, run `gh pr checkout
  $ARGUMENTS`, commit on top (TDD: failing test first), run `make test`, and `git push`. Do not
  rewrite or squash the contributor's commits.
- Otherwise, request changes with specific line references (`gh pr review --request-changes`).

## 6. Merge

```bash
gh pr merge $ARGUMENTS --merge
```

If the PR went to `main`, sync `next` afterwards (confirm first):

```bash
git switch next && git pull --ff-only && git merge --no-ff origin/main && make test && git push
```

## 7. Close the loop

- **PR comment:** thank the author by handle, and summarize any commits you pushed on top and
  why.
- **Linked issue:** give the root cause (with the commit that introduced it), say which PR
  fixed it, and give upgrade steps (`zpm upgrade @zpm`, then `zpm clean` and `exec zsh`). Make
  sure the issue is closed.
- If the fix should reach users before the next minor, propose a patch release
  (`.claude/skills/release/SKILL.md`).
