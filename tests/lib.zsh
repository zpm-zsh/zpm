
if [[ "$CLICOLOR" != "0" ]]; then
  typeset -gA c

  c_reset="[0m"
  c_bold="[1m"

  c[black]="[30m"
  c[red]="[31m"
  c[green]="[32m"
  c[yellow]="[33m"
  c[blue]="[34m"
  c[magenta]="[35m"
  c[cyan]="[36m"
  c[grey]="[37m"
fi


function assert_pass() {
  echo "${c[green]}Pass:${c_reset} $1 ${c[green]}✔${c_reset}"
}

function assert_fail() {
  echo "${c[red]}Fail:${c_reset} $1 ${c[red]}✖${c_reset}"
}


function assert() {
  if [[ "$2" == "equal" ]]; then
    if [[ "$1" == "$3" ]]; then
      echo "${c[green]}Pass:${c_reset} ${c[yellow]}'${c_reset}$1${c[yellow]}'${c_reset} ${c[cyan]}==${c_reset} ${c[yellow]}'${c_reset}$3${c[yellow]}'${c_reset} ${c[green]}✔${c_reset}"
    else
      echo "${c[red]}Fail:${c_reset} ${c[yellow]}'${c_reset}$1${c[yellow]}'${c_reset} ${c[cyan]}!=${c_reset} ${c[yellow]}'${c_reset}$3${c[yellow]}'${c_reset} ${c[red]}✖${c_reset}"
    fi
  fi

  if [[ "$2" == "not_equal_to" ]]; then
    if [[ "$1" != "$3" ]]; then
      echo "${c[green]}Pass:${c_reset} ${c[yellow]}'${c_reset}$1${c[yellow]}'${c_reset} ${c[cyan]}!=${c_reset} ${c[yellow]}'${c_reset}$3${c[yellow]}'${c_reset} ${c[green]}✔${c_reset}"
    else
      echo "${c[red]}Fail:${c_reset} ${c[yellow]}'${c_reset}$1${c[yellow]}'${c_reset} ${c[cyan]}==${c_reset} ${c[yellow]}'${c_reset}$3${c[yellow]}'${c_reset} ${c[red]}✖${c_reset}"
    fi
  fi

  if [[ "$2" == "contains" ]]; then
    if [[ "$1" == *"$3"* ]]; then
      echo "${c[green]}Pass:${c_reset} ${c[yellow]}'${c_reset}$1${c[yellow]}'${c_reset} ${c[cyan]}contains${c_reset} ${c[yellow]}'${c_reset}$3${c[yellow]}'${c_reset} ${c[green]}✔${c_reset}"
    else
      echo "${c[red]}Fail:${c_reset} ${c[yellow]}'${c_reset}$1${c[yellow]}'${c_reset} ${c[cyan]}doesn't contains${c_reset} ${c[yellow]}'${c_reset}$3${c[yellow]}'${c_reset} ${c[red]}✖${c_reset}"
    fi
  fi

}