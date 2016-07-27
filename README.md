# ZPM - Zsh Plugin Manager

ZPM ( Zsh plugin manager ) is an yet another plugin manager for
[zsh](http://www.zsh.org/) similar to vim-plug.
ZPM plugins are compatible with [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).
ZPM runs on Linux, Android, FreeBSD and OS X.

## Dependences

* git
* zsh
* [Termux](http://termux.com/) for Android

## Instalation

### From GitHub

Add following text into `.zshrc`

```sh
if [[ ! -f ~/.zpm/zpm.zsh ]]; then
    git clone --recursive https://github.com/horosgrisa/zpm ~/.zpm
    source ~/.zpm/zpm.zsh
fi
```

If you don't have `.zshrc` copy example of `.zshrc` from zpm

```sh
cp ~/.zpm/zshrc-example.zsh ~/.zshrc
```

### From Aur (Arch Linux)

```sh
yaourt -S zpm
cp /usr/share/zpm/zshrc-example ~/.zshrc
```

## Using plugins

* Add `Plug some-plugin` for enabling plugin from `~/.zpm/plugins`
* Or add `Plug github-user/github-repo` for enabling plugin from github.
