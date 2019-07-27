# ZPM - Zsh Plugin Manager

ZPM ( Zsh plugin manager ) is an yet another plugin manager for [zsh](http://www.zsh.org/).

* ZPM plugins are compatible with [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).
* ZPM runs on Linux, Android, FreeBSD and macOS.
* It supports dependencies between packages. 
* Upgrade hooks


## Base dependences

* git
* zsh
* [Termux](http://termux.com/) for Android

## Instalation

#### From GitHub

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

## Using plugins

Add `zpm load github-user/github-repo` for enabling plugin from github.

Or `zpm load-if condition github-user/github-repo` for conditionally loading plugin

Or `zpm load-if-not condition github-user/github-repo` for loading plugin if condition is not met 

Conditions:
* `linux` - if current OS is Linux
* `bsd` - if current OS is *BSD
* `macos` - if current OS is macOS
* `termux` - if current session run in [Termux](http://termux.com/)
* `ssh` - if session run on remote host
* `tmux` - if session run in Tmux

## Upgrade

Run `zpm upgrade` for upgrading, or run `zpm upgrade some-plugin` if you want upgrade one of plugins
