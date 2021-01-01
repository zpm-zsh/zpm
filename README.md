# ZPM - Zsh Plugin Manager

> Zpm is **NOT** a yet another plugin manager for [zsh](http://www.zsh.org/).

Zpm is a plugin manager for ZSH who combines the imperative and declarative approach. At first run, zpm will do complex logic and generate cache, after that will be used cache only, so it makes this framework to be very fast.

* Fastest plugin manager (Really, after the first run, zpm will not be used at all)
* Support for async loading
* Dependencies between packages
* Many hooks
* Function autoloading
* ZPM plugins are compatible with [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
* ZPM runs on Linux, Android, FreeBSD and macOS
* Extensible

---

* [Stats](#stats)
* [Base dependences](#base-dependences)
* [Instalation](#instalation)
* [How to use](#how-to-use)
  * [Load plugin](#load-plugin)
  * [Tags](#tags)
  * [`if` and `if-not` conditions](#if-and-if-not-conditions)
  * [Upgrade](#upgrade)
  * [Clean](#clean)
* [Troubleshooting](#troubleshooting)
* [Changelog](#changelog)

---

## Stats

<details>
  <summary>Test on Intel I7-8750H, SanDisk SD7SN6S, 16GB RAM</summary>
<p>

```sh
zsh -i -c exit  0.00s user 0.00s system 100% cpu 0.008 total
zsh -i -c exit  0.01s user 0.00s system 100% cpu 0.008 total
zsh -i -c exit  0.01s user 0.00s system 101% cpu 0.008 total
zsh -i -c exit  0.01s user 0.00s system 102% cpu 0.008 total
zsh -i -c exit  0.01s user 0.00s system 101% cpu 0.008 total
zsh -i -c exit  0.00s user 0.00s system 101% cpu 0.008 total
zsh -i -c exit  0.01s user 0.00s system 102% cpu 0.008 total
zsh -i -c exit  0.01s user 0.00s system 101% cpu 0.009 total
zsh -i -c exit  0.01s user 0.00s system 101% cpu 0.008 total
zsh -i -c exit  0.01s user 0.00s system 102% cpu 0.008 total

```

</p>
</details>

<details>
  <summary>With this set of plugins. 48 total</summary>
<p>

```sh
zpm-zsh/helpers
zpm-zsh/colors
zpm-zsh/background
zpm-zsh/vte
zpm-zsh/core-config
zpm-zsh/check-deps
zpm-zsh/minimal-theme
zpm-zsh/pr-user
zpm-zsh/zpm-telemetry
zpm-zsh/btrfs
zpm-zsh/zpm-readme
zpm-zsh/zpm-info
zpm-zsh/ignored-users
zpm-zsh/material-colors
zpm-zsh/pr-is-root
zpm-zsh/pr-return
zpm-zsh/pr-exec-time
sindresorhus/pretty-time-zsh
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
omz/extract
omz/command-not-found
omz/wp-cli
zpm-zsh/template
```

</p>
</details>

## Base dependences

* zsh
* git
* xargs
* [Termux](http://termux.com/) for Android
* [Rush](https://github.com/shenwei356/rush) for fastest parallel execution, optional
* [cli-html](https://www.npmjs.com/package/cli-markdown) view html in terminal, optional
* [cli-markdown](https://www.npmjs.com/package/cli-markdown) view markdown in terminal, optional

## Instalation

Add the following text into `.zshrc`

```sh
if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh
```

If you don't have `.zshrc` copy example of `.zshrc` from zpm

```sh
cp ~/.zpm/zshrc ~/.zshrc
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

Plugin name must have next form: `user/plugin-name`. This plugin can be enabled using

```sh
# Add to `~/.zshrc` after zpm initialization:
zpm load user/plugin-name
```

> Notice: if you change `~/.zshrc`, you need to remove zpm cache using: `zpm clean`

Additionaly they can have some tags. Tags must be separated by commas `,` without spaces, tag parameters must be separated from tag names or another tag parameters by `:`

```sh
#     plugin name
#   ⬀          tag
#   |         ⬀      tag parameters, divided by :
#   |         |    ⬀                   boolean tag
#   |         |    |                 ⬀
#   ↓         ↓    ↓                 ↓
some/plugin,apply:source:path:fpath,async
```

### Tags

Zpm supports tags for plugins:

#### `type` tag

This tag has the following parameters:

* `type:github` - plugin will be downloaded from GitHub, this is default value, so you don't need to set it
* `type:gitlab` - plugin will be downloaded from GitLab
* `type:bitbucket` - plugin will be downloaded from Bitbucket
* `type:omz` - zpm will use a plugin from oh-my-zsh, oh-my-zsh will be download if not installed. Can be ommited if your plugin name starts with `@omz/`
* `type:empty` - special type, zpm will create empty dir without files. Useful with `hook`, `gen-completion` and `gen-plugin` tags. Can be ommited if your plugin name starts with `@empty/`

```sh
plugin-from/github  # type:github doesn't necessary
plugin-from/gitlab,type:gitlab
plugin-from/bitbucket,type:bitbucket
oh-my-zsh/some-plugin,type:omz
@omz/another-plugin
custom/empty-plugin,type:empty
@empty/another-empty-plugin
```

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

#### `autoload-all` tag

If this tag present all files from [functions directory](#path-and-fpath-tags) of this plugin will be autoloaded. Exception for files who starts with `_` or ends with `.zwc`

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

## Changelog

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
