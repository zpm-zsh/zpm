# ZPM - Zsh Plugin Manager

ZPM ( Zsh plugin manager ) is *NOT* an yet another plugin manager for [zsh](http://www.zsh.org/).

* ZPM plugins are compatible with [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).
* ZPM runs on Linux, Android, FreeBSD and macOS.
* It supports dependencies between packages. 
* And it is very, very fast
* Alslo, it supports async load of plugins

## Base dependences

* git
* zsh
* [Termux](http://termux.com/) for Android

## Instalation

Add following text into `.zshrc`

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

# How to use

Add `zpm load github-user/github-repo` for enabling plugin from github.

Or `zpm if condition load github-user/github-repo` for conditionally loading plugin

Or `zpm if-not condition load github-user/github-repo` for loading plugin if condition is not met 

### Conditions:

* `linux` - if current OS is Linux
* `bsd` - if current OS is *BSD
* `macos` - if current OS is macOS
* `termux` - if current session run in [Termux](http://termux.com/)
* `ssh` - if session run on remote host
* `tmux` - if session run in Tmux

Condition can be combined `zpm if ssh if tmux if-not macos load repo/plugin`

### Tags

Zpm supports tags for plugins:

##### `apply` tag

`some/plugin,apply:source:path:fpath`

This tag have 4 posible arguments: 

* `source` - for source this plugin, enabled by default
* `path` - add `/bin` folder to your `$PATH`, only if it exist, enabled by default
* `fpath` - add plugin folder to your `$fpath`, only if exist at least one `_*` file, enabled by default

##### `path` and `fpath` tags

Using this tags you can change destination of folders which will be added to `$PATH` or `$fpath`

```sh
zpm some/plugin,path:/other-bin-folder
zpm another/plugin,fpath:/completions
```

##### `async` tag

If this tag is present, zsh plugin will be loaded async

## Upgrade

Run `zpm upgrade` for upgrading, or run `zpm upgrade some-plugin` if you want upgrade one of plugins
