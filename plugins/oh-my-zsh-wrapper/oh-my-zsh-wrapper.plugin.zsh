#!/usr/bin/env zsh


for plugin ($plugins); do
    if [ -f ~/.oh-my-zsh/plugins/$plugin/$plugin.plugin.zsh ]; then
        source ~/.oh-my-zsh/plugins/$plugin/$plugin.plugin.zsh
    fi
done

for plugin ($plugins); do
    fpath=(~/.oh-my-zsh/plugins/$plugin $fpath)
done
