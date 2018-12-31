#!/usr/bin/env zsh

setopt correct
if [[ "$CLICOLOR" = 1 ]]; then
  SPROMPT="$fg[cyan] Change '$fg[red]%R$fg[cyan]' to '$fg[green]%r$fg[cyan]'? ($fg[green]Yes$fg[cyan], $fg[red]No$fg[cyan], $fg[red]Abort$fg[cyan], $fg[yellow]Edit$fg[cyan]) $fg[blue]> $reset_color"
else
  SPROMPT=" Change '%R' to '%r'? (Yes, No, Abort, Edit) > "
fi
