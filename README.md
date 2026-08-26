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
- [Base dependences](#base-dependences)
- [Installation](#installation)
- [CLI Commands & Aliases](#cli-commands--aliases)
  - [`zpm load`](#zpm-load)
  - [`zpm upgrade`](#zpm-upgrade-zpm-u-zpm-up)
  - [`zpm clean`](#zpm-clean-zpm-c-zpm-cl)
  - [`zpm info`](#zpm-info)
  - [`zpm list`](#zpm-list-zpm-ls)
  - [`zpm readme`](#zpm-readme)
  - [`zpm link`](#zpm-link)
  - [Custom Commands Extension](#custom-commands-extension)
- [How to use](#how-to-use)
  - [Plugin Name & Types](#plugin-name--types)
  - [Plugin Tags](#plugin-tags)
  - [Conditional Loading (`if` and `if-not`)](#conditional-loading-if-and-if-not)
- [Cookbook & Common Examples](#cookbook--common-examples)
- [Configuration & Environment Variables](#configuration--environment-variables)
- [Guide for Plugin Authors](#guide-for-plugin-authors)
- [Troubleshooting](#troubleshooting)
- [Developing process](#developing-process)
- [TODO](#todo)
- [Changelog](#changelog)

## Stats

ZPM achieves near-instant shell startup by combining all loaded plugins and configurations into a single byte-compiled cache (`zpm-cache.zsh.zwc`) and asynchronous runner (`zpm-cache-async.zsh.zwc`). On subsequent shell startups, no plugin manager logic or filesystem lookups are executed—only the pre-compiled cache is sourced.

| Plugin Manager / Setup | Cold Start / Initialization | Warm Interactive Startup (50+ plugins) |
|---|---|---|
| **ZPM** | ~0.8s – 2.0s (first run only) | **~0.006s – 0.050s** (compiled cache) |
| **Zinit (Turbo mode)** | ~0.5s – 1.5s | ~0.100s – 0.150s |
| **Oh-My-Zsh** | N/A (linear sourcing) | ~0.200s – 0.450s |
| **Antigen** | ~1.0s – 3.0s | ~0.250s – 0.500s |

<details>
  <summary>Benchmark details on Intel I7-8750H, SanDisk SD7SN6S, 16GB RAM</summary>
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
  <summary>With this set of plugins (51 total)</summary>
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

## Base dependences

- [zsh](https://www.zsh.org/) (>= 5.1)
- [git](https://git-scm.com/)
- One of these for parallel downloading:
  - [GNU Parallel](https://www.gnu.org/software/parallel/)
  - [Rush](https://github.com/shenwei356/rush)
  - [xargs](https://www.gnu.org/software/findutils/) (standard fallback)
- [curl](https://curl.se/) for remote downloads and GitHub Gists
- [Termux](http://termux.com/) for Android
- [cli-markdown](https://www.npmjs.com/package/cli-markdown) / [cli-html](https://www.npmjs.com/package/cli-html) / [glow](https://github.com/charmbracelet/glow) / [bat](https://github.com/sharkdp/bat) — *optional, for `zpm readme` terminal viewer*

## Installation

Add the following to your `~/.zshrc`:

```sh
ZPM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/@zpm"
if [[ ! -f "${ZPM_DIR}/zpm.zsh" ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm "${ZPM_DIR}"
fi
source "${ZPM_DIR}/zpm.zsh"
```

If you don't have a `.zshrc`, you can copy the provided example:

```sh
ln -sf "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/@zpm/zshrc" ~/.zshrc
```

## CLI Commands & Aliases

| Command | Aliases | Description |
|---|---|---|
| `zpm load <plugins...>` | *(default)* | Download and initialize specified plugins |
| `zpm upgrade [plugins...]` | `zpm u`, `zpm up` | Upgrade all plugins (or specific plugins), then clear cache and reload |
| `zpm clean` | `zpm c`, `zpm cl` | Remove generated ZPM cache (`$ZSH_TMP_DIR`) and restart shell |
| `zpm info [plugins...]` | | Display detailed metadata card for specified plugin(s) |
| `zpm list` | `zpm ls` | List all loaded/installed plugins |
| `zpm readme <plugin>` | | Display plugin's README in the terminal |
| `zpm link [path]` | | Link and load a local directory or single script as a plugin |
| `zpm if <condition> <command>` | | Execute command only if condition is true on first run |
| `zpm if-not <condition> <command>` | | Execute command only if condition is false on first run |
| `zpm <custom-command>` | | Execute custom subcommand function `zpm-<custom-command>` |

### `zpm load`
Downloads, resolves, and loads one or more plugins into the current shell and registers them for inclusion in the pre-compiled startup cache.

```sh
zpm load zsh-users/zsh-autosuggestions
zpm load @omz/git @omz/extract
```

### `zpm upgrade` (`zpm u`, `zpm up`)
Updates git repositories and remote plugins to their latest versions. Running without arguments updates all installed plugins (including `@zpm` itself). You can also pass specific plugin names to update only them:

```sh
zpm u                                  # update all plugins
zpm u zsh-users/zsh-autosuggestions    # update only a specific plugin
```

### `zpm clean` (`zpm c`, `zpm cl`)
Purges the generated runtime cache in `$ZSH_TMP_DIR` (including byte-compiled cache and aggregated binary/completion files) and restarts the shell with `exec zsh`. Use this whenever you edit your `~/.zshrc`.

```sh
zpm clean
# or simply
zpm c
```

### `zpm info`
Displays detailed metadata for one or more plugins, including origin repository URL, plugin type, sync/async mode, local installation path, and current installation status:

```sh
zpm info zsh-users/zsh-autosuggestions
zpm info @zpm
```

### `zpm list` (`zpm ls`)
Lists all plugins currently loaded or installed in your ZPM environment with their metadata:

```sh
zpm list
# or
zpm ls
```

### `zpm readme`
Displays the `README.md` documentation for any installed plugin directly in your terminal. Automatically detects available terminal markdown renderers (`cli-markdown`, `md`, `cli-html`, `glow`, `bat`, or system `$PAGER`):

```sh
zpm readme zsh-users/zsh-autosuggestions
zpm readme @zpm
```

### `zpm link`
Quickly symlinks and loads a local directory or standalone `.zsh` script into your current session (analogous to `npm link`). It automatically detects whether the target is a directory or single file, generates the appropriate `@dir` / `@file` spec, loads it immediately, and prints the exact snippet to add to your `~/.zshrc`:

```sh
# In plugin's repository directory:
zpm link

# Or by providing a path:
zpm link ~/Projects/my-awesome-plugin
zpm link ~/.dotfiles/zsh/custom-aliases.zsh
```

### Custom Commands Extension
You can easily extend ZPM with custom commands! Any shell function named `zpm-<subcommand>` will be automatically called when executing `zpm <subcommand>`:

```sh
function zpm-hello() {
  echo "Hello from custom ZPM command! Arguments: $@"
}

zpm hello world
# Output: Hello from custom ZPM command! Arguments: world
```

## How to use

### Basic Syntax

```sh
zpm load [@type/]plugin-name[,tag1:val1,tag2,...]
```

> **Note**: If you modify `~/.zshrc`, apply your changes by running `zpm clean` (or `zpm c`).

```sh
# plugin type (optional, defaults to @github)
#    |   plugin name
#    |      |     tag
#    |      |      |  tag parameter(s)
#    |      |      |  separated by `:`    boolean tag
#    |      |      |         |              |
#    ↓      ↓      ↓         ↓              ↓
zpm load @type/some/plugin,apply:source:path:fpath,async
```

### Plugin Name & Types

| Type Prefix | Origin / Behavior | Example |
|---|---|---|
| *(none)* or `@github/` / `@gh/` | Cloned from GitHub *(default)* | `zpm load zsh-users/zsh-autosuggestions` |
| `@gitlab/` or `@gl/` | Cloned from GitLab | `zpm load @gitlab/user/repo` |
| `@bitbucket/` or `@bb/` | Cloned from Bitbucket | `zpm load @bitbucket/user/repo` |
| `@git/` | Cloned from any Git URL via `origin:` tag | `zpm load @git/custom,origin:https://git.example.com/repo.git` |
| `@gist/` | Downloaded from GitHub Gist | `zpm load @gist/username/gist_id` |
| `@remote/` | Single file downloaded via `curl` | `zpm load @remote/prompt,origin:https://example.com/prompt.zsh` |
| `@dir/` / `@link/` | Symlinked from a local directory | `zpm load @dir/my-plugin,origin:$HOME/Projects/my-plugin` |
| `@file/` | Symlinked from a single local file | `zpm load @file/my-script,origin:$HOME/dotfiles/script.zsh` |
| `@exec/` | Output generated by executing shell command | `zpm load @exec/kubectl-completion,origin:"kubectl completion zsh",destination:completion` |
| `@empty/` | Creates an empty directory (useful with `hook:`) | `zpm load @empty/custom-tool,hook:"cargo install ..."` |
| `@omz` | Clones oh-my-zsh core repository | `zpm load @omz` |
| `@omz/plugin-name` | Loads plugin from `<omz-dir>/plugins/` | `zpm load @omz/git` |
| `@omz/theme/theme-name` | Loads theme from `<omz-dir>/themes/` | `zpm load @omz/theme/robbyrussell` |
| `@omz/lib/lib-name` | Loads library from `<omz-dir>/lib/` | `zpm load @omz/lib/completion` |

> **Important for Oh-My-Zsh**: Load `@omz` before loading individual OMZ plugins, themes, or libraries.

### Plugin Tags

#### `apply`
Controls what components of the plugin are activated. Takes colon-separated values:
- `source` — source the main plugin script file *(enabled by default)*.
- `path` — add plugin's `bin/` directory to `$PATH` *(enabled by default if `bin/` exists)*.
- `fpath` — add plugin's `functions/` (or completions) directory to `$fpath` *(enabled by default)*.

```sh
# Only add completions to $fpath without sourcing any script
zpm load zsh-users/zsh-completions,apply:fpath

# Only add bin/ executables to $PATH
zpm load some/cli-tool,apply:path
```

#### `async`
Defers plugin sourcing until after the primary prompt is rendered, significantly speeding up initial shell display.

```sh
zpm load zsh-users/zsh-autosuggestions,async
zpm load zdharma-continuum/fast-syntax-highlighting,async
```

#### `destination`
Specifies how downloaded files or generated outputs should be placed within the plugin directory:
- `plugin` *(default)* — saved as `<name>.zsh` and sourced.
- `completion` — saved into `functions/_<basename>` as an autoloadable completion file.
- `bin` — saved into `bin/<basename>` and **automatically marked executable** (`chmod +x`).

```sh
# Download a standalone CLI tool and make it executable in $PATH
zpm load @remote/git-standup,origin:https://raw.githubusercontent.com/kamranahmedse/git-standup/master/git-standup,destination:bin

# Generate completion dynamically on install
zpm load @exec/rustup-completion,origin:"rustup completions zsh",destination:completion
```

#### `source`
Specifies a custom script file to source if the main entry file cannot be detected automatically.

```sh
zpm load some/plugin,source:custom-init.zsh
```

#### `path` and `fpath`
Specifies custom directory locations within the plugin to add to `$PATH` or `$fpath`.

```sh
zpm load some/plugin,path:executables
zpm load some/plugin,fpath:completions
```

#### `autoload`
Declares functions to be autoloaded on demand (`autoload -Uz`).

```sh
zpm load some/plugin,autoload:func1:func2:func3
```

#### `origin`
Overrides the download or clone source URL / path / command.

```sh
zpm load @git/private-plugin,origin:git@github.com:company/private-plugin.git
zpm load @dir/local-theme,origin:$HOME/.dotfiles/themes/my-theme
```

#### `hook`
Runs a shell command in the plugin directory immediately after installation or upgrade.

```sh
zpm load junegunn/fzf,hook:"./install --bin"
zpm load romkatv/powerlevel10k,hook:"git submodule update --init --recursive"
```

### Conditional Loading (`if` and `if-not`)

Load plugins conditionally based on the operating system or environment. Conditions are evaluated during cache generation on first run.

```sh
zpm if <condition> load <plugin>
zpm if-not <condition> load <plugin>
```

#### Available Conditions:
- `linux` — Linux operating system
- `macos` — macOS (Darwin)
- `bsd` — BSD variants (FreeBSD, OpenBSD, NetBSD)
- `openwrt` — OpenWrt router environment
- `termux` — Android Termux
- `ssh` — Remote SSH session (`$SSH_CONNECTION` / `$SSH_TTY`)
- `vte` — Terminal emulator with VTE support
- `msys` — MSYS / Cygwin environment on Windows
- `vscode` — Integrated terminal in VS Code
- `iterm` — iTerm2 terminal emulator

Conditions can be chained:

```sh
# Only load on macOS and when not connected over SSH
zpm if macos if-not ssh load zpm-zsh/iterm
```

## Cookbook & Common Examples

### 1. Oh-My-Zsh Plugins & Themes
```sh
# Step 1: Clone OMZ core
zpm load @omz

# Step 2: Load required libraries
zpm load              \
  @omz/lib/completion \
  @omz/lib/history    \
  @omz/lib/key-bindings

# Step 3: Load OMZ plugins and theme
zpm load @omz/git @omz/extract
zpm load @omz/theme/robbyrussell
```

### 2. High-Performance Modern Setup (Async Plugins)
```sh
# Immediate sync loading
zpm load zpm-zsh/helpers
zpm load romkatv/powerlevel10k

# Async deferred loading
zpm load zsh-users/zsh-autosuggestions,async
zpm load zdharma-continuum/fast-syntax-highlighting,async
zpm load zsh-users/zsh-history-substring-search,async
```

### 3. Local Plugin & Single-File Development
```sh
# Symlink entire local repository
zpm load @dir/my-plugin,origin:$HOME/Projects/zsh-my-plugin

# Symlink a standalone snippet/script
zpm load @file/aliases,origin:$HOME/.dotfiles/zsh/aliases.zsh
```

### 4. Completions and Standalone Binaries
```sh
# Add completions from repo without sourcing anything
zpm load zsh-users/zsh-completions,apply:fpath

# Download single-file binary and expose to $PATH
zpm load @remote/git-quick-stats,origin:https://raw.githubusercontent.com/arzzen/git-quick-stats/master/git-quick-stats,destination:bin
```

## Configuration & Environment Variables

| Variable | Default | Description |
|---|---|---|
| `_ZPM_PARALLEL_RUNNER` | `auto` (`parallel` -> `rush` -> `xargs`) | Force runner for concurrent downloads (`parallel`, `rush`, `xargs`) |
| `CLICOLOR` | `1` | Set `CLICOLOR=0` to disable ANSI colors in terminal output |
| `DEBUG` | *(none)* | Enable debug logging. Supports prefixes: `DEBUG=zpm`, `DEBUG=zpm:init`, `DEBUG=zpm:install`, `DEBUG=zpm:upgrade` |
| `GITHUB_MIRROR` | `https://github.com` | Custom mirror URL for GitHub |
| `GITLAB_MIRROR` | `https://gitlab.com` | Custom mirror URL for GitLab |
| `BITBUCKET_MIRROR` | `https://bitbucket.org` | Custom mirror URL for Bitbucket |
| `ZSH_DATA_HOME` | `${XDG_DATA_HOME:-$HOME/.local/share}/zsh` | Root directory for installed plugins |
| `ZSH_CACHE_HOME` | `${XDG_CACHE_HOME:-$HOME/.cache}/zsh` | Root directory for `zcompdump` |
| `ZSH_TMP_DIR` | `/tmp/zsh-${UID:-user}` | Directory for compiled cache, aggregated functions and bin files |

```sh
# Example: configuration before sourcing zpm.zsh
export _ZPM_PARALLEL_RUNNER="xargs"
export GITHUB_MIRROR="https://hub.fastgit.org"
```

## Guide for Plugin Authors

If you are authoring a plugin, you can include a `plugin-options.zsh` file in the root of your repository. ZPM will automatically read this file before initializing the plugin:

```zsh
# plugin-options.zsh
zpm_plugin_source=true          # set to false if the plugin should not be sourced
zpm_plugin_async=false          # set to true if the plugin should always load asynchronously
zpm_plugin_bin_path=true        # add plugin's bin/ to $PATH
zpm_plugin_functions_path=true  # add plugin's functions/ to $fpath
zpm_plugin_autoload="foo:bar"   # functions to autoload automatically
```

## Troubleshooting

### Built-in Compatibility Workarounds
ZPM automatically detects and applies optimizations for popular plugins:
- **`romkatv/powerlevel10k`**: `POWERLEVEL9K_INSTALLATION_DIR` is automatically configured in cache.
- **`zsh-syntax-highlighting`** & **`zsh-history-substring-search`**: Main entry files are resolved automatically.
- **`sindresorhus/pure`**: Prompt function paths are resolved automatically.

### Clearing Cache and Updating ZPM
If you modify your `.zshrc` or encounter corrupted cache files:

```sh
# Quick cache refresh
zpm clean

# Updating ZPM itself
zpm upgrade @zpm
```

## Developing process

> Set `DEBUG=zpm` to view verbose debug logs during plugin resolution and caching.

When contributing changes, add information about them to the changelog in the **next** section, including pull request and profile links.

## TODO

- [x] Create logo
- [x] Improve readme
  - [x] Describe installation process
  - [x] Describe all tags, plugin types, and configuration options
- [ ] Improve completions
  - [ ] Now `zpm load`, `zpm upgrade` or `zpm subcommand` will complete only one argument

## Changelog

- 6.1

  - Move zpm default location to `$XDG_DATA_HOME/zsh/plugins/@zpm`
  - Prevent `@zpm-compile` from compiling `.git` refs when `setopt GLOB_DOTS` is enabled
  - Fix installation paths in README
  - Add benchmarking comparison in README
  - Stop exporting internal parameters into child shells
  - Add `-fSL` flag to let curl follow redirections

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
