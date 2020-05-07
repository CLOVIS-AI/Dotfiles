#!/usr/bin/env zsh

[[ ! -v CLOVIS_CONFIG ]] && CLOVIS_CONFIG=~/config

function source-selector-sh() {
	emulate -L bash
	builtin source "$@"
}

source-selector-sh "$CLOVIS_CONFIG"/selector.sh "$@" --no-completion --no-autofetch

# Completion
autoload -Uz compinit
compinit

# Automatically CD to directories
setopt autocd

# Use Emacs key bindings
bindkey -e
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Options and traps defined in functions are local
setopt localoptions localtraps

# Commands in prompts should be expanded
setopt promptsubst

# History management
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory incappendhistory histignoredups

# More powerful globs
setopt extendedglob

# Correct what I'm typing
setopt correct

# Get my prompt
# shellcheck source=zsh-prompt.sh
. "$CLOVIS_CONFIG"/zsh-prompt.sh
