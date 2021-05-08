# ZPM - Zsh Plugin Manager

> Fastest, configurable and extensible zsh plugin manager

Zpm is a plugin manager for ZSH who combines the imperative and declarative approach. At first run, zpm will do complex logic and generate cache, after that will be used cache only, so it makes this framework to be very fast.

## Features

* **Speed**. Fastest plugin manager (Really, after the first run, zpm will not be used at all)
* **Compatibility**. Zpm plugins are compatible with [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
* **Portability**. Zpm runs on Linux, Android, OpenWrt, FreeBSD and macOS
* Support for async loading
* Dependencies between packages
* Hooks
* Function autoloading
* Extensible

## Table of Contents

* [Features](#features)
* [Table of Contents](#table-of-contents)
* [Stats](#stats)
* [Base dependences](#base-dependences)
* [Installation](#installation)
* [How to use](#how-to-use)
  * [Load plugin](#load-plugin)
  * [Plugin name](#plugin-name)
  * [Plugin tags](#plugin-tags)
  * [`if` and `if-not` conditions](#if-and-if-not-conditions)
  * [Upgrade](#upgrade)
  * [Clean](#clean)
* [Troubleshooting](#troubleshooting)
* [Developing process](#developing-process)
* [TODO](#todo)
* [Changelog](#changelog)

## Stats

<details>
  <summary>Test on Intel I7-8750H, SanDisk SD7SN6S, 16GB RAM</summary>
<p>

```sh
zsh -i -c exit  0.01s user 0.00s system 101% cpu 0.007 total
zsh -i -c exit  0.00s user 0.00s system 102% cpu 0.007 total
zsh -i -c exit  0.01s user 0.00s system 100% cpu 0.007 total
zsh -i -c exit  0.00s user 0.00s system 99% cpu 0.008 total
zsh -i -c exit  0.01s user 0.00s system 101% cpu 0.007 total
zsh -i -c exit  0.01s user 0.00s system 101% cpu 0.007 total
zsh -i -c exit  0.00s user 0.00s system 101% cpu 0.007 total
zsh -i -c exit  0.00s user 0.01s system 101% cpu 0.007 total
zsh -i -c exit  0.01s user 0.00s system 101% cpu 0.007 total
zsh -i -c exit  0.00s user 0.00s system 102% cpu 0.007 total

```

</p>
</details>

<details>
  <summary>Test on MikroTik RouterBOARD 951Ui-2HnD, Atheros AR9344 rev 3, MIPS 74Kc V4.12, 128MB RAM</summary>
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

## Base dependences

* [zsh](https://www.zsh.org/)
* [git](https://git-scm.com/)
* One of these:
  * [GNU Parallel](https://www.gnu.org/software/parallel/) for fastest parallel execution.
  * [Rush](https://github.com/shenwei356/rush) for fastest parallel execution.
  * [xargs](https://www.gnu.org/software/findutils/) as fallback
* [Termux](http://termux.com/) for Android
* [cli-html](https://www.npmjs.com/package/cli-markdown) view html in terminal. *Optional*
* [cli-markdown](https://www.npmjs.com/package/cli-markdown) view markdown in terminal. *Optional*

## Installation

Add the following text into `.zshrc`

```sh
if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh
```

If you don't have `.zshrc` copy example of `.zshrc` from zpm

```sh
ln -sf ~/.zpm/zshrc ~/.zshrc
```

## How to use

Currently zpm has following commands

* load - will download and load plugin [See](#load-plugin)
* if/if-not - conditions for following command [See](#if-and-if-not-conditions)
* upgrade - will upgrade plugin, without parameters will upgrade all plugins [See](#upgrade)
* clean - will clean zpm cache [See](#clean)

The set of commands can be expanded extended using plugins

<details>
<summary>Plugins for zpm itself</summary>
<p>

* [zpm-readme](https://github.com/zpm-zsh/zpm-readme) - Show plugin readme in terminal
* [zpm-info](https://github.com/zpm-zsh/zpm-info) - Show plugin info in terminal
* [zpm-telemetry](https://github.com/zpm-zsh/zpm-telemetry) - Send telemetry data. Keep calm. Data is sent using GitHub and you can see it before sending.

</p>
</details>

### Load plugin

**Important**

> Be carefully, zpm doesnt guarantue loading order in call. So if you need to load a plugin **before** antoher, you should do 2 separate `zpm load` calls.
> This is very important for oh-my-zsh plugins, because @omz-core should be loaded before

Plugin name must have next form: `user/plugin-name`. This plugin can be enabled using

```sh
# Add to `~/.zshrc` after zpm initialization:
zpm load user/plugin-name
```

> Notice: if you change `~/.zshrc`, you need to remove zpm cache using: `zpm clean`

Additionaly they can have some tags. Tags must be separated by commas `,` without spaces, tag parameters must be separated from tag names or another tag parameters by `:`

```sh
# plugin type
#    |   plugin name
#    |      |        tag
#    |      |         |  tag parameters, divided by :
#    |      |         |            |       boolean tag
#    |      |         |            |             |
#    ↓      ↓         ↓            ↓             ↓
@type/some/plugin,apply:source:path:fpath,async
```

### Plugin name

If plugin name starts with `@word`, this word will be used as plugin type. Plugin name will be used to detect plugin repository url.

* `@github/` or `@gh/` - plugin will be downloaded from GitHub, this is default value, so you don't need to set it
* `@gitlab/` or `@gl/` - plugin will be downloaded from GitLab
* `@bitbucket/` or `@bb/` - plugin will be downloaded from Bitbucket
* `@omz/` - zpm will use a plugin from oh-my-zsh, oh-my-zsh will be download if not installed. **Important**: you shoud load `@omz` before any other plugin from on-my-zsh. `zpm load @omz`.
  * `@omz-theme/` - will load a theme from omz. From `<omz-dir>/themes/*.zsh-theme`
  * `@omz-lib/` - will load a lib from omz. From `<omz-dir>/lib/*.zsh`
  * <details>
    <summary>
    Example:
    </summary>
    <p>

    See: <https://github.com/zpm-zsh/zpm/issues/24>

    ```sh
    # Pull in OMZ (doesn't actually source anything)
    zpm load @omz

    # Load any OMZ libraries we want or our OMZ plugins require
    zpm load                \
      @omz-lib/compfix      \
      @omz-lib/completion   \
      @omz-lib/directories  \
      @omz-lib/functions    \
      @omz-lib/git          \
      @omz-lib/grep         \
      @omz-lib/history      \
      @omz-lib/key-bindings \
      @omz-lib/misc         \
      @omz-lib/spectrum     \
      @omz-lib/theme-and-appearance

      # Load some OMZ plugins and theme
      zpm load          \
        @omz/virtualenv \
        @omz/git

      zpm load @omz-theme/robbyrussell
    ```

    </p>
    </details>
* `@empty/` - special type, zpm will create empty dir without files. Useful with `hook`, `gen-completion` and `gen-plugin` tags. Can be ommited if your plugin name starts with `@empty/`

```sh
plugin-from/github  # @github doesn't necessary
@gitlab/plugin-from/gitlab
@bitbucket/plugin-from/bitbucket
@omz/some-plugin
@empty/custom/empty-plugin
@empty/another-empty-plugin
```

### Plugin tags

#### `apply` tag

This tag has 3 possible arguments divided by `:`

* `source` - load zsh plugin file, enabled by default. File name can be changed using `source` tag
* `path` - add directory to your `$PATH`, by default - `/bin` dir, enabled by default. Directory name can be changed using `path` tag
* `fpath` - add directory to your `$fpath`, by default or `/functions` dir if it exists, or plugin root dir if exist at least one `_*` file, enabled by default. Directory name can be changed using `fpath` tag

```sh
zpm load some/plugin,apply:source:path:fpath
zpm load another/plugin,apply:path # zpm will only add /bin dir to $PATH, plugin will not be sourced, nor be added to $fpath
```

#### `async` tag

If this tag is present, zsh plugin will be loaded async

#### `origin` tag

This tag can be used for define or redefine repo origin of plugin. Example:

```sh
zpm load some/plugin,origin:https://github.com/another/origin # This plugin will be loaded from https://github.com/another/origin, but will have internal name some/plugin

zpm load git/my-plugin,git://my.site/plugin.git # This plugin will be loaded from 3-party origin

zpm load @link/plugin,origin:/home/user/Projects/plugin # This plugin directory will be linked to your local directory
```

This tag have no sense with another plugin types like `@omz`, `@omz-core`, `@omz-theme`

#### `source` tag

Define own file that will be loaded

```sh
zpm some/plugin,source:/other.file.zsh
```

#### `path` and `fpath` tags

Using these tags you can change the destination of folders which will be added to `$PATH` or `$fpath`

```sh
zpm some/plugin,path:/executables
zpm another/plugin,fpath:/completions
```

#### `autoload` tag

This tag defines functions that will be autoloaded by zpm (using `autoload -Uz`) divided by `:`

```sh
zpm load some/plugin,autoload:one:two:three
```

#### `hook` tag

This tag parameter contains command who will be run in the plugin directory after instalation or upgrade

```sh
zpm plugin/name,hook:"make; make install"
```

#### `gen-plugin` tag

This tag parameter contains command who can generate zsh plugin file

```sh
zpm @empty/npm,gen-plugin:"npm completion"
```

#### `gen-completion` tag

This tag parameter contains command who can generate zsh completions file

```sh
zpm @empty/rustup,gen-completion:"rustup completions zsh"
```

### `if` and `if-not` conditions

If condition allows you to run the following commands only if the condition is true

```sh
zpm if some-condition (another commands)
```

Conditions:

* `linux` - if current OS is Linux
* `bsd` - if current OS is *BSD
* `openwrt` - if current OS is OpenWrt
* `macos` - if current OS is macOS
* `termux` - if current session run in [Termux](http://termux.com/)
* `ssh` - if session run on remote host
* `vte` - if session run on VTE based terminal emulator

Result of condition can be negated using `if-not` tag

The condition can be combined `zpm if macos if-not ssh load repo/plugin`

> Notice: conditions will be verified only at first run, after that will be used generated cache

### Upgrade

Run `zpm upgrade` for upgrading, or run `zpm upgrade some-plugin another-plugin` if you want to upgrade only these plugins

### Clean

By default zpm will generate cache file at first run, but if you will change `~/.zshrc` this cache should be removed using `zpm clean` command

## Troubleshooting

If you have problems with zpm try:

```sh
rm -rf "${TMPDIR:-/tmp}/zsh-${UID:-user}"
cd ~/.zpm
git pull
```

## Developing process

> You can see debug information by setting the system variable `DEBUG=zpm`

When you make changes, add information about them to the change log in **next** section. Also add link to pr and link to your GitHub profile.

## TODO

* [ ] Improve readme
  * [ ] Describe installation process
* [ ] Improve completions
  * [ ] Now `zpm load`, `zpm upgrade` or `zpm subcommand` will complete only one argument

## Changelog

* 3.4
  * Added GNU Parallel

* 3.3
  * Added `origin` tag
  * Removed `autoload-all` tag

* 3.2
  * Fix plugin load order
  * Use sched for background run

* 3.1
  * Fix completions
  * Add example for @omz

* 3.0
  * Remove unused `@link`
  * Remove `tr` calls
  * Deprecate `type:` tag
  * Internal changes for basename/name,hyperlink
  * Add support for oh-my-zsh themes and libs
    * `zpm load @omz-theme/theme-name`
    * `zpm load @omz-lib/lib`
  * Upgrade from 2.x:
    * Add `zpm load @omz` if you are yousing at least one oh-my-zsh plugin.
    * Replace `type:plugin-type` with `@plugin-type/plugin/name`

* 2.3
  * Improve **README**
  * Remove suppot for `zsh_loaded_plugins`
  * Add config for Markdownlint

* 2.2
  * Add support for OpenWrt
  * Improve oh-my-zsh-support [@igetgames](https://github.com/igetgames)
  * Support for calling plugin functions from command tags [@igetgames](https://github.com/igetgames)
  * Fix autoload option processing [@igetgames](https://github.com/igetgames)
* 2.1
  * Optimizations
  * Now all content of `/functions` and `/bin` will be copied into single dir, in zpm cache dir
  * Change `zpm` to `@zpm`
  * Remove unused vars
  * Some vars will be loaded async
  * Fixed colors
  * Notes
    * Now for update zpm need to run `zpm u @zpm`
* 2.0
  * `omz/` prefix replaced by `@omz/`
  * Added plugin type `empty`
  * Added `autoload` and `autoload-all` tags
  * Added `gen-plugin` and `gen-completion` tags
  * Notes:
    * Replace `omz/` to `@omz/` in your `.zshrc`
