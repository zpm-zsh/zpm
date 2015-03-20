# ZPM - Zsh Plugin Manager

ZPM ( Zsh plugin manager ) is an yet another plugin manager for [zsh](http://www.zsh.org/) similar to vim-plug. ZPM compatible with oh-my-zsh. 

## Dependences
* `git`
* `zsh`

## Instalation 

* Add 
```
if [[ ! -f ~/.zpm/zpm.zsh ]]; then
    git clone --recursive https://github.com/horosgrisa/ZPM ~/.zpm
fi
```
into `.zshrc`

* If you don't have `.zshrc` copy example of zshrc from ZPM
```
cp ~/.zpm/zshrc-example ~/.zshrc
```

## Using plugins

* Add `Plug some-plugin` for enabling plugin from `~/.zpm/plugins`
* Or add `Plug github-user/github-repo` for enabling plugin from github.

