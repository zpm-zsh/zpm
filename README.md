# ZPM - Zsh Plugin Manager

ZPM ( Zsh plugin manager ) is **NOT** a yet another plugin manager for [zsh](http://www.zsh.org/).
zpm ( ZSH Plugin Manager ) is a plugin manager for ZSH who combines the imperative and declarative approach. At first run, zpm will do complex logic and generate cache, after that will be used cache only, so it makes this framework to be very fast.

* Fastest plugin manager (Really, after the first run, zpm will not be used at all)
* Support for async loading
* Dependencies between packages
* ZPM plugins are compatible with [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* ZPM runs on Linux, Android, FreeBSD and macOS
* Extensible 

<details>
  <summary>Extensions for zpm itself</summary>
<p>

* [zpm-readme](https://github.com/zpm-zsh/zpm-readme) - Show plugin readme in terminal
* [zpm-info](https://github.com/zpm-zsh/zpm-info) - Show plugin info in terminal
* [zpm-bugreport](https://github.com/zpm-zsh/zpm-bugreport) - Quickly create bugreport for zsh plugin
* [zpm-telemetry](https://github.com/zpm-zsh/zpm-telemetry) - Send telemetry data. Keep calm. Data is sent using GitHub and you can see it before sending.

</p>
</details>


#### Stats

<details>
  <summary>Test on Intel I7-8750H, SanDisk SD7SN6S, 16GB RAM</summary>
<p>

```sh
zsh -i -c exit  0.01s user 0.00s system 100% cpu 0.010 total
zsh -i -c exit  0.01s user 0.00s system 101% cpu 0.010 total
zsh -i -c exit  0.01s user 0.00s system 100% cpu 0.012 total
zsh -i -c exit  0.00s user 0.01s system 100% cpu 0.010 total
zsh -i -c exit  0.00s user 0.00s system 101% cpu 0.008 total
zsh -i -c exit  0.01s user 0.00s system 100% cpu 0.010 total
zsh -i -c exit  0.01s user 0.00s system 99% cpu 0.010 total
zsh -i -c exit  0.01s user 0.00s system 100% cpu 0.009 total
zsh -i -c exit  0.01s user 0.00s system 99% cpu 0.010 total
zsh -i -c exit  0.01s user 0.00s system 103% cpu 0.010 total
```

</p>
</details>

## Base dependences

* zsh
* git
* xargs
* [Termux](http://termux.com/) for Android
* [Rush](https://github.com/shenwei356/rush) - optional

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

Add your zpm commands to `~/.zshrc` after zpm initialization:

```sh
zpm load github-user/github-repo # Download and enable the plugin from GitHub

zpm if linux load github-user/github-repo # Load plugin only on Linux

zpm if-not linux load github-user/github-repo # Don't load the plugin on Linux

zpm load gitlab-user/gitlab-repo,type:gitlab # Download and enable plugin from GitLab

zpm load bitbucket-user/bitbucket-repo,type:bitbucket # Download and enable the plugin from Bitbucket

zpm load plugin-form-oh-my-zsh,type:omz # Load plugin form oh-my-zsh
zpm load omz/plugin-name                # Load plugin form oh-my-zsh

zpm load github-user/github-repo,async # Async load

```
> Notice: if you change `~/.zshrc`, you need to remove zpm cache: `zpm clean`

### `if` conditions:

* `linux` - if current OS is Linux
* `bsd` - if current OS is *BSD
* `macos` - if current OS is macOS
* `termux` - if current session run in [Termux](http://termux.com/)
* `ssh` - if session run on remote host
* `vte` - if session run on VTE based terminal emulator

The condition can be combined `zpm if macos if-not ssh load repo/plugin`

### Tags

Zpm supports tags for plugins:

##### `apply` tag

This tag has 3 possible arguments: 

* `source` - for source this plugin, enabled by default
* `path` - add `/bin` folder to your `$PATH`, only if it exists, enabled by default
* `fpath` - add plugin folder to your `$fpath`, only if exist at least one `_*` file, enabled by default

`some/plugin,apply:source:path:fpath`

##### `async` tag

If this tag is present, zsh plugin will be loaded async

##### `source` tag

Define own file woh will be load

```sh
zpm some/plugin,source:/other.file.zsh
```

##### `path` and `fpath` tags

Using these tags you can change the destination of folders which will be added to `$PATH` or `$fpath`

```sh
zpm some/plugin,path:/executables
zpm another/plugin,fpath:/completions
```

##### `type` tag

This tag has the following parameters:

* `type:gitlab` - plugin will be downloaded from GitLab
* `type:bitbucket` - plugin will be downloaded from Bitbucket
* `type:omz` - zpm  will use a plugin from oh-my-zsh, oh-my-zsh will be download if not installed

```sh
plugin-from/gitlab,type:gitlab
plugin-from/bitbucket,type:bitbucket
plugin-form-oh-my-zsh,type:omz
```

##### `hook` tag

This tag param contains command who will be run in the plugin directory

```sh
zpm plugin/name,hook:"make; make install"
```

## Upgrade

Run `zpm upgrade` for upgrading, or run `zpm upgrade some-plugin another-plugin` if you want to upgrade only these plugins
