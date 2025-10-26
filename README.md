<p align="center">
  <img alt="Logo" src="images/logo.svg" height="180" />
  <h1 align="center">ZPM - Zsh Plugin Manager</h1>
  <p align="center">
    Fastest, configurable and extensible zsh plugin manager
  </p>
  <p align="center">
    <a href="/LICENSE">
      <img alt="Software License" src="https://img.shields.io/github/license/zpm-zsh/zpm?style=flat-square">
    </a>
    <img alt="Travis" src="https://img.shields.io/github/languages/code-size/zpm-zsh/zpm?style=flat-square">
    <img alt="Go Report Card" src="https://img.shields.io/github/last-commit/zpm-zsh/zpm?logo=github&style=flat-square">
  </p>
</p>

Zpm is a plugin manager for ZSH who combines the imperative and declarative approach. At first run, zpm will do complex logic and generate cache, after that will be used cache only, so it makes this framework to be very fast.

<p align="center">
  <img src="images/demo.gif" width="100%">
</p>

## Features

- **Speed**. Fastest plugin manager (Really, after the first run, zpm will not be used at all)
- **Compatibility**. Zpm plugins are compatible with [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- **Portability**. Zpm runs on Linux, Android, OpenWrt, FreeBSD and macOS
- Support for async loading
- Dependencies between packages
- Hooks
- Function autoloading
- Extensible
- Possibility to use github/gitlab/bitbucket mirrors (useful for China)

## Table of Contents

- [Features](#features)
- [Table of Contents](#table-of-contents)
- [Stats](#stats)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
  - [Install](#install)
  - [Minimal `.zshrc`](#minimal-zshrc)
  - [Load Your First Plugin](#load-your-first-plugin)
- [Command Reference](#command-reference)
  - [load](#load)
  - [if and if-not](#if-and-if-not)
  - [upgrade](#upgrade)
  - [clean](#clean)
- [Plugin Specification](#plugin-specification)
  - [Plugin Identifiers](#plugin-identifiers)
  - [Plugin Tags](#plugin-tags)
    - [`apply` tag](#apply-tag)
    - [`async` tag](#async-tag)
    - [`source` tag](#source-tag)
    - [`path` and `fpath` tags](#path-and-fpath-tags)
    - [`autoload` tag](#autoload-tag)
    - [`origin` tag](#origin-tag)
    - [`hook` tag](#hook-tag)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Developing process](#developing-process)
- [TODO](#todo)
- [Changelog](#changelog)

## Stats

<details>
  <summary>Test on Intel I7-8750H, SanDisk SD7SN6S, 16GB RAM</summary>
<p>

```sh
zsh -i -c exit  0.00s user 0.00s system 102% cpu 0.006 total
zsh -i -c exit  0.01s user 0.00s system 101% cpu 0.006 total
zsh -i -c exit  0.00s user 0.01s system 99% cpu 0.006 total
zsh -i -c exit  0.01s user 0.00s system 102% cpu 0.007 total
zsh -i -c exit  0.00s user 0.00s system 100% cpu 0.007 total
zsh -i -c exit  0.01s user 0.00s system 100% cpu 0.007 total
zsh -i -c exit  0.00s user 0.00s system 101% cpu 0.007 total
zsh -i -c exit  0.00s user 0.00s system 100% cpu 0.006 total
zsh -i -c exit  0.00s user 0.00s system 101% cpu 0.007 total
zsh -i -c exit  0.00s user 0.00s system 100% cpu 0.008 total
```

</p>
</details>

<details>
  <summary>Test on Raspberry Pi Zero W, Raspbian 10, 1GHz Broadcom BCM2835 ARMv6, 512MB RAM</summary>
<p>

```sh
zsh -i -c exit  0.14s user 0.05s system 85% cpu 0.219 total
zsh -i -c exit  0.14s user 0.05s system 43% cpu 0.436 total
zsh -i -c exit  0.14s user 0.05s system 58% cpu 0.325 total
zsh -i -c exit  0.12s user 0.07s system 90% cpu 0.206 total
zsh -i -c exit  0.15s user 0.05s system 84% cpu 0.231 total
zsh -i -c exit  0.15s user 0.04s system 46% cpu 0.407 total
zsh -i -c exit  0.13s user 0.06s system 62% cpu 0.306 total
zsh -i -c exit  0.11s user 0.08s system 83% cpu 0.227 total
zsh -i -c exit  0.14s user 0.05s system 47% cpu 0.403 total
zsh -i -c exit  0.11s user 0.08s system 62% cpu 0.307 total
```

</p>
</details>

<details>
  <summary>Test on MikroTik RouterBOARD 951Ui-2HnD, OpenWrt 19.07.7, 600MHz Atheros AR9344 MIPS, 128MB RAM</summary>
<p>

```sh
zsh -i -c exit  0.09s user 0.03s system 83% cpu 0.144 total
zsh -i -c exit  0.10s user 0.02s system 29% cpu 0.412 total
zsh -i -c exit  0.10s user 0.02s system 69% cpu 0.173 total
zsh -i -c exit  0.10s user 0.03s system 73% cpu 0.165 total
zsh -i -c exit  0.10s user 0.02s system 81% cpu 0.150 total
zsh -i -c exit  0.10s user 0.02s system 71% cpu 0.170 total
zsh -i -c exit  0.10s user 0.02s system 85% cpu 0.141 total
zsh -i -c exit  0.10s user 0.02s system 42% cpu 0.283 total
zsh -i -c exit  0.11s user 0.02s system 68% cpu 0.176 total
zsh -i -c exit  0.10s user 0.02s system 75% cpu 0.161 total
```

</p>
</details>

<details>
  <summary>With this set of plugins. 51 total</summary>
<p>

```sh
zpm-zsh/helpers
zpm-zsh/colors
zpm-zsh/tmux
zpm-zsh/vte
zpm-zsh/core-config
zpm-zsh/ignored-users
zpm-zsh/check-deps
zpm-zsh/minimal-theme
zpm-zsh/material-colors
zpm-zsh/pr-is-root
zpm-zsh/pr-user
zpm-zsh/pr-return
zpm-zsh/pr-exec-time
zpm-zsh/pretty-time-zsh
zpm-zsh/pr-git
zpm-zsh/pr-cwd
zpm-zsh/pr-php
zpm-zsh/pr-rust
zpm-zsh/pr-node
zpm-zsh/pr-2
zpm-zsh/pr-eol
zpm-zsh/pr-zcalc
zpm-zsh/pr-correct
zpm-zsh/ls
zpm-zsh/colorize
zpm-zsh/ssh
zpm-zsh/dot
zpm-zsh/undollar
zpm-zsh/dropbox
lukechilds/zsh-better-npm-completion
zpm-zsh/clipboard
zpm-zsh/mysql-colorize
zpm-zsh/zshmarks
voronkovich/gitignore.plugin.zsh
zpm-zsh/autoenv
mdumitru/fancy-ctrl-z
zsh-users/zsh-history-substring-search
zdharma/fast-syntax-highlighting
zsh-users/zsh-autosuggestions
psprint/history-search-multi-word
zpm-zsh/zpm-readme
zpm-zsh/zpm-info
zpm-zsh/zpm-telemetry
zpm-zsh/zpm-link
@omz/extract
@omz/command-not-found
@omz/pip
@empty/npm
@empty/rustup
zpm-zsh/create-zsh-plugin
```

</p>
</details>

## Requirements

- [zsh](https://www.zsh.org/)
- [git](https://git-scm.com/)
- One of these:
  - [GNU Parallel](https://www.gnu.org/software/parallel/) for fastest parallel execution.
  - [Rush](https://github.com/shenwei356/rush) for fastest parallel execution.
  - [xargs](https://www.gnu.org/software/findutils/) as fallback
- [curl](https://curl.se/) for GitHub Gists
- [Termux](http://termux.com/) for Android
- [cli-html](https://www.npmjs.com/package/cli-html) view html in terminal. _Optional_
- [cli-markdown](https://www.npmjs.com/package/cli-markdown) view markdown in terminal. _Optional_

## Quick Start

### Install

1. Make sure the [requirements](#requirements) are available.
2. Clone ZPM into your local plugin directory (defaults to `${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/@zpm`):

   ```sh
   if [[ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/@zpm" ]]; then
     git clone --recursive https://github.com/zpm-zsh/zpm "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/@zpm"
   fi
   ```

3. Source the entry point from your shell init file:

   ```sh
   source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/@zpm/zpm.zsh"
   ```

   Prefer keeping your own shell configuration. If you want to start from the sample config instead, symlink it deliberately:

   ```sh
   ln -sf "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/@zpm/zshrc" ~/.zshrc
   ```

### Minimal `.zshrc`

```sh
# Optional: customize cache/data paths before sourcing ZPM
# export ZSH_CACHE_HOME=~/tmp/.cache/zsh
# export ZSH_DATA_HOME=~/tmp/.local/share/zsh

source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/@zpm/zpm.zsh"

# Load a few defaults
zpm load zpm-zsh/helpers
zpm load zpm-zsh/core-config
```

This snippet is enough to bootstrap the manager and a couple of bundled helpers. Feel free to append more `zpm load …` lines underneath.

### Load Your First Plugin

Call `zpm load <plugin>` anywhere after sourcing `zpm.zsh`. Plugin identifiers follow the pattern `@type/user/repo`; see the [Plugin Specification](#plugin-specification) for every supported form.

```sh
zpm load romkatv/powerlevel10k
zpm load @omz/lib/git
```

> ZPM resolves dependencies in batches and does not guarantee load order within a single `zpm load …` command. Issue additional `zpm load` calls when order matters (e.g., load `@omz` before an oh-my-zsh plugin).

When you edit your `.zshrc`, remove the generated cache to regenerate it on the next login:

```sh
zpm clean
```

## Command Reference

Core commands ship with ZPM, and additional subcommands can be installed via plugins (`_zpm_extend_commands`). The built-in verbs are:

- `load` — fetch and activate plugins
- `if` / `if-not` — guard a subsequent command with condition checks
- `upgrade` — refresh plugins
- `clean` — purge caches and restart the shell

<details>
<summary>Plugins extending the ZPM CLI</summary>
<p>

- [zpm-readme](https://github.com/zpm-zsh/zpm-readme) — show plugin README files in the terminal
- [zpm-info](https://github.com/zpm-zsh/zpm-info) — print plugin metadata
- [zpm-telemetry](https://github.com/zpm-zsh/zpm-telemetry) — inspect what telemetry would be sent to GitHub

</p>
</details>

### load

Fetches plugins that are missing locally, adds their `bin/` and `functions/` trees to the staging directories, and sources their entry files (synchronously or asynchronously).

```sh
zpm load zpm-zsh/helpers zsh-users/zsh-autosuggestions
```

Prefer separate `zpm load` calls when strict ordering is required. This is critical for oh-my-zsh plugins — always load `@omz` first.

### if and if-not

Wrap one or more ZPM commands so they only execute when a condition matches. Conditions are evaluated while the cache is built, therefore the result is memoized for subsequent shells.

```sh
zpm if linux load rupa/z
zpm if termux if-not ssh load some/mobile-only-plugin
```

Supported conditions:

- `linux` — Linux distribution
- `bsd` — any \*BSD
- `openwrt` — OpenWrt
- `macos` — macOS
- `termux` — running under [Termux](http://termux.com/)
- `ssh` — remote session (checks `$SSH_TTY`)
- `vte` — VTE-based terminal emulator

Negate the result with `if-not`, and chain multiple guards: `zpm if macos if-not ssh load repo/plugin`.

### upgrade

Refresh one or more plugins by pulling the latest version (or re-running their origin action for non-git sources).

```sh
zpm upgrade                   # upgrade every tracked plugin
zpm upgrade romkatv/powerlevel10k @omz/lib/git
```

After an upgrade ZPM clears its cache and re-executes your shell so the new code takes effect immediately.

### clean

Remove the generated cache and restart the current shell. Run this after structural changes to your dotfiles or when switching branches that affect plugin configuration.

```sh
zpm clean
```

## Plugin Specification

Plugins are described by an identifier plus optional comma-separated tags. The identifier decides how ZPM fetches the code; tags fine-tune loading behaviour.

### Plugin Identifiers

If a name starts with `@type/`, the prefix controls the origin. Without a prefix ZPM assumes GitHub (`user/repo`).

- `@github/` or `@gh/` — clone from GitHub (default)
- `@gitlab/` or `@gl/` — clone from GitLab
- `@bitbucket/` or `@bb/` — clone from Bitbucket
- `@git/` — generic git clone; supply an `origin:` tag
- `@gist/` — download a GitHub Gist
- `@omz/` — reuse content from oh-my-zsh (ZPM installs OMZ if missing)
  - `@omz/theme/` — load `<omz>/themes/*.zsh-theme`
  - `@omz/lib/` — load `<omz>/lib/*.zsh`
- `@dir/` — link to a local directory (requires `origin:`)
- `@file/` — link to a single local file (requires `origin:`)
- `@remote/` — download with `curl` (requires `origin:`)
- `@exec/` — run a command to generate the plugin files (uses `origin:` content)
- `@empty/` — create an empty directory (handy with hooks or manual content)

Example:

```sh
zpm load plugin-from/github          # same as github/plugin-from/github
zpm load @gitlab/user/project        # GitLab
zpm load @omz/lib/git                # oh-my-zsh lib
zpm load @dir/local,origin:$PWD/lib  # symlink local sources
```

See [issue #24](https://github.com/zpm-zsh/zpm/issues/24) for a full oh-my-zsh wiring example.

### Plugin Tags

Append comma-separated tags to tweak how ZPM integrates a plugin. Tag parameters follow the tag name and are separated by `:`. Boolean tags (such as `async`) do not take parameters.

```sh
# type      repo            tags...
# │         │               │
@type/some/plugin,apply:source:path:fpath,async
```

#### `apply` tag

Enable or disable the default integration steps. Provide one or more of `source`, `path`, `fpath` (all enabled by default).

- `source` — run the plugin entry script (see `source` tag to pick the file)
- `path` — add the plugin’s `bin/` directory (or custom path) to `$PATH`
- `fpath` — add completions/functions to `$fpath`

```sh
zpm load some/plugin,apply:source:path:fpath
zpm load another/plugin,apply:path   # only export executables
```

#### `async` tag

Source the plugin asynchronously after prompt initialization. Use this for slow plugins that do not need to block the shell.

#### `source` tag

Pick a specific file to source instead of the heuristics ZPM applies.

```sh
zpm load some/plugin,source:init/entry.zsh
```

#### `path` and `fpath` tags

Override which directories are copied into ZPM’s staging `bin/` or `functions/` folders.

```sh
zpm load some/plugin,path:executables
zpm load another/plugin,fpath:completions
```

#### `autoload` tag

Request additional function autoloads (`autoload -Uz`) right after the plugin is sourced. Separate multiple entries with `:`.

```sh
zpm load some/plugin,autoload:one:two:three
```

#### `origin` tag

Provide the concrete origin when ZPM cannot infer it (generic git, remote file, dir/file/exec plugins). Keep origins consistent with the identifier type.

- Git-based types (`@github`, `@gitlab`, `@bitbucket`, `@git`)

  ```sh
  zpm load some/plugin,origin:https://github.com/another/origin
  zpm load @git/my-plugin,origin:git://my.site/plugin.git
  ```

- Remote downloads (`@gist`, `@remote`)

  ```sh
  zpm load @gist/user/hash,origin:https://another-site/file.zsh
  zpm load @remote/plugin,origin:https://mysite.com/plugin.zsh
  ```

- Local links (`@dir`, `@file`)

  ```sh
  zpm load @dir/plugin,origin:/home/user/Projects/plugin
  zpm load @file/plugin-file,origin:/home/user/Projects/plugin.zsh
  ```

- Special types (`@empty`, `@omz`, `@omz/theme`, `@omz/lib`) manage their origin automatically — do not override it.

#### `hook` tag

Run shell code inside the plugin directory right after install or upgrade (e.g., compile assets).

```sh
zpm load plugin/name,hook:"make && make install"
```

## Configuration

### Mirrors

Set these variables before sourcing ZPM to route git traffic through mirrors:

```sh
GITHUB_MIRROR="https://hub.fastgit.org"
GITLAB_MIRROR="https://gitlab.example.com"
BITBUCKET_MIRROR="https://bitbucket.example.com"
```

### Parallel runner

ZPM picks `parallel`, `rush`, or `xargs` automatically. Override the choice by exporting `_ZPM_PARALLEL_RUNNER` before loading:

```sh
export _ZPM_PARALLEL_RUNNER=xargs   # or parallel / rush
```

### Cache and data directories

All paths can be customized ahead of time:

- `ZSH_TMP_DIR` — scratch directory used to stage compiled caches and helper binaries (defaults to `${TMPDIR:-/tmp}/zsh-${UID:-user}`).
- `ZSH_DATA_HOME` — persistent plugin store (defaults to `${XDG_DATA_HOME:-$HOME/.local/share}/zsh`).
- `ZSH_CACHE_HOME` — location for compinit caches (defaults to `${XDG_CACHE_HOME:-$HOME/.cache}/zsh`).

Example:

```sh
export ZSH_DATA_HOME="$HOME/.config/zsh"
export ZSH_CACHE_HOME="$HOME/.cache/zsh"
export ZSH_TMP_DIR="$HOME/.cache/zsh/tmp"
source "${ZSH_DATA_HOME}/plugins/@zpm/zpm.zsh"
```

### Debug logging

Enable targeted debug output by exporting `DEBUG=zpm:init` (or another prefix). ZPM hashes the prefix to pick a color and prints matching log lines during the next cache rebuild.

## Troubleshooting

### Powerlevel10k

Powerlevel10k loads extra modules in its installation directory, which it [automatically detects by taking the file containing its init code, making it absolute, and taking its directory](https://github.com/romkatv/powerlevel10k/blob/0cc19ac2ede35fd8accff590fa71df580dc7e109/powerlevel10k.zsh-theme#L20). However, as zpm combines plugins into one fast-loading cache file, this automatic detection would break.

As a workaround, you have to explicitly tell Powerlevel10k where it is installed. This needs to be done before the cache file is loaded, which means before zpm itself is loaded, like this:

```sh
ZPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
export POWERLEVEL9K_INSTALLATION_DIR="${ZPM_HOME}/romkatv---powerlevel10k"
source "${ZPM_HOME}/@zpm/zpm.zsh"

# ...

zpm load romkatv/powerlevel10k
```

### Update to latest zpm

If you have problems with `zpm` try updating:

```sh
rm -rf "${TMPDIR:-/tmp}/zsh-${UID:-user}" # clear the cache
ZPM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/@zpm"
git -C "$ZPM_DIR" pull
```

## Developing process

> You can see debug information by setting the system variable `DEBUG=zpm`

When you make changes, add information about them to the change log in **next** section. Also add link to pr and link to your GitHub profile.

## TODO

- [x] Create logo
- [ ] Improve readme
  - [ ] Describe installation process
- [ ] Improve completions
  - [ ] Now `zpm load`, `zpm upgrade` or `zpm subcommand` will complete only one argument

## Changelog

- 7.0

  - Move zpm to `$XDG_DATA_HOME/zsh/plugins/zpm`

- 6.0

  - Add workarouds for powerlevel10k, zsh-syntax-highlighting, zsh-history-substring-search, sindresorhus/pure

- 5.3

  - Change plugin file path detector

- 5.2

  - Remove old omz tag

- 5.1

  - Change internal functions

- 5.0

  - Removed `gen-plugin` and `gen-completion` tags
  - `@omz-theme/` and `@omz-lib/` changed to `@omz/theme/` and `@omz/lib/`

- 4.2

  - Replace `$ZERO` with `$0`. Fixed [#43](https://github.com/zpm-zsh/zpm/issues/43)
  - Update README. [#44](https://github.com/zpm-zsh/zpm/pull/44)

- 4.1

  - Added possibility to change parallel runner, e.g. GNU Parallel, Rush, Xargs
  - Optimize plugin load
  - Change some plugin urls

- 4.0

  - Refactoring of internal logic
  - Added new plugin types: `@gist`, `@remote`

- 3.6

  - Added new plugin types `@dir` and `@file`
  - `@link` now is an alias for `@dir`
  - Fixed [#35](https://github.com/zpm-zsh/zpm/issues/35)

- 3.5

  - Added new logo
  - Added possibility to use mirrors for GitHub/Gitlab/Bitbucket. See [issue](https://github.com/zpm-zsh/zpm/issues/31)

- 3.4

  - Added GNU Parallel

- 3.3

  - Added `origin` tag
  - Removed `autoload-all` tag

- 3.2

  - Fix plugin load order
  - Use sched for background run

- 3.1

  - Fix completions
  - Add example for @omz

- 3.0

  - Remove unused `@link`
  - Remove `tr` calls
  - Deprecate `type:` tag
  - Internal changes for basename/name,hyperlink
  - Add support for oh-my-zsh themes and libs
    - `zpm load @omz-theme/theme-name`
    - `zpm load @omz-lib/lib`
  - Upgrade from 2.x:
    - Add `zpm load @omz` if you use at least one oh-my-zsh plugin.
    - Replace `type:plugin-type` with `@plugin-type/plugin/name`

- 2.3

  - Improve **README**
  - Remove suppot for `zsh_loaded_plugins`
  - Add config for Markdownlint

- 2.2

  - Add support for OpenWrt
  - Improve oh-my-zsh-support [@igetgames](https://github.com/igetgames)
  - Support for calling plugin functions from command tags [@igetgames](https://github.com/igetgames)
  - Fix autoload option processing [@igetgames](https://github.com/igetgames)

- 2.1

  - Optimizations
  - Now all content of `/functions` and `/bin` will be copied into single dir, in zpm cache dir
  - Change `zpm` to `@zpm`
  - Remove unused vars
  - Some vars will be loaded async
  - Fixed colors
  - Notes
    - Now for update zpm need to run `zpm u @zpm`

- 2.0
  - `omz/` prefix replaced by `@omz/`
  - Added plugin type `empty`
  - Added `autoload` and `autoload-all` tags
  - Added `gen-plugin` and `gen-completion` tags
  - Notes:
    - Replace `omz/` to `@omz/` in your `.zshrc`
