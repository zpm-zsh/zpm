setopt correct
if [[ "$COLORS" == "true" ]]; then
SPROMPT="$fg_bold[cyan] Change $fg_bold[grey]'$fg_bold[red]%R$fg_bold[grey]'$fg_bold[cyan] to $fg_bold[grey]'$reset_color$fg_bold[green]%r$reset_color$fg_bold[grey]'$reset_color? ($fg_bold[grey]Y$reset_color$fg_bold[green]es$reset_color, $fg_bold[grey]N$reset_color$fg_bold[red]o$reset_color, $fg_bold[grey]A$reset_color$fg_bold[red]bort$reset_color, $fg_bold[grey]E$reset_color$fg_bold[blue]dit$reset_color) $fg_bold[green]>$reset_color "


    SPROMPT="$fg[cyan] Change '$fg[red]%R$fg[cyan]' to '$fg[green]%r$fg[cyan]'? ($fg[green]Yes$fg[cyan], $fg[red]No$fg[cyan], $fg[red]Abort$fg[cyan], $fg[yellow]Edit$fg[cyan]) $fg[blue]> $reset_color"
else
    SPROMPT=" Change '%R' to '%r'? (Yes, No, Abort, Edit) > "
fi
