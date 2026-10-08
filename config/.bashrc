

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s extglob
shopt -s globstar
shopt -s checkjobs



if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/p3k8rvhgb5w21g0majimz2jnd11xb0fx-bash-completion-2.18.0/etc/profile.d/bash_completion.sh"
fi

PS1="\[\033[0;32m\]\u@\h:\w\$ \[\033[0m\]"

source -- ~/.local/share/blesh/ble.sh
source -- ~/.local/share/blesh/ble.sh
source -- ~/.local/share/blesh/ble.sh

alias gn="git add ./* && git commit && git push origin main"

