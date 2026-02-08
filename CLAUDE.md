# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
make all      # Format all files with beautysh (indent-size 2, fnpar style)
make clean    # Remove .zwc compiled files
make test     # Run zsh tests/base.test.zsh

# Manual testing: clear cache and restart shell
rm -rf "${TMPDIR:-/tmp}/zsh-${UID}"
exec zsh

# Enable debug logging
DEBUG=zpm exec zsh
```

## Architecture

ZPM is a **cache-first** zsh plugin manager. On first run it installs plugins, generates a cache file, and compiles it. On subsequent runs, only the cache is sourced (~6ms startup).

### Boot flow

```
zpm.zsh (entry point)
  ├── Cache exists? → source $_ZPM_CACHE (fast path)
  └── No cache? → eval lib/init.zsh + lib/imperative.zsh (slow path)
        ├── init.zsh: declare arrays, autoload all @zpm-* functions
        ├── imperative.zsh: mkdir, detect parallel runner, load helpers,
        │   schedule @zpm-background-initialization via sched +1
        └── User calls `zpm load ...` which triggers @zpm-load-plugins
```

### Core loading pipeline

```
zpm load <plugin-spec>
  → @zpm-load-plugins       # batch entry point
    → @zpm-get-plugin-name   # extract name from spec
    → @zpm-get-plugin-path   # resolve install path
    → @zpm-launch-plugin-helper install  # parallel install if missing
    → @zpm-initialize-plugin # parse tags, add to fpath/PATH, source
```

After all plugins load, `@zpm-background-initialization` generates two cache files:
- `$ZSH_TMP_DIR/zpm-cache.zsh` — sync plugins (loaded on startup)
- `$ZSH_TMP_DIR/zpm-cache-async.zsh` — async plugins (scheduled)

Both are zcompiled by `@zpm-compile`.

### Key data structures

| Variable | Type | Purpose |
|---|---|---|
| `_ZPM_plugins_full` | assoc array | plugin name → full spec string |
| `_ZPM_file_for_source` | assoc array | plugin name → source file path |
| `_ZPM_plugins_for_source` | array | plugins to include in sync cache |
| `_ZPM_plugins_for_async_source` | array | plugins for async cache |
| `_ZPM_autoload` | array | functions to `autoload -Uz` |

### File layout

- `zpm.zsh` — entry point (40 lines), sets env vars, loads cache or initializes
- `lib/init.zsh` — declares data structures, autoloads all core functions
- `lib/imperative.zsh` — first-run setup: dirs, parallel runner detection, helpers load
- `functions/@zpm-*` — one function per file, all autoloaded (this is the core logic)
- `functions/zpm` — the `zpm` command itself (dispatches to subcommands)
- `functions/_zpm` — zsh completions for the `zpm` command
- `bin/@zpm-plugin-helper` — standalone script for install/upgrade (runs in parallel)

### Plugin type system

Plugins are specified as `@type/user/plugin-name,tag1,tag2:param`. Types: `@github` (default), `@gitlab`, `@bitbucket`, `@git`, `@omz`, `@gist`, `@remote`, `@dir`, `@file`, `@exec`, `@empty`.

Tags: `apply:source:path:fpath`, `async`, `source:file`, `path:dir`, `fpath:dir`, `autoload:fn1:fn2`, `origin:url`, `hook:cmd`, `destination:bin`.

### Parallel execution

Plugin install/upgrade runs via one of (detected in order): GNU Parallel, Rush, xargs. Override with `_ZPM_PARALLEL_RUNNER=parallel|rush|xargs`.

### Known workarounds

Hardcoded special handling exists in `@zpm-get-plugin-file-path` and `@zpm-background-initialization` for: powerlevel10k, zsh-syntax-highlighting, zsh-history-substring-search, sindresorhus/pure.

## Conventions

- All core functions are prefixed `@zpm-` and live in `functions/` as individual files for autoloading
- Follows PMSPEC `0fbs` (Zsh Plugin Standard)
- The `ZERO` (`$0`) variable is set during plugin sourcing so plugins can find their own directory
- The `source` builtin is overridden during init to auto-zcompile files
- Cache invalidation: conditions stored in `$ZSH_TMP_DIR/is`, regenerated on mismatch or `zpm clean`
