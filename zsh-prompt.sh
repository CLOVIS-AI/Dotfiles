#!/usr/bin/env zsh

# Prompt
autoload colors
colors
precmd() {
	current_branch=$(git-data --current 2>/dev/null || echo "none")
	autofetch_options=""
	[[ $current_branch != "$last_branch" ]] && autofetch_options="--changelog"
	last_branch=$current_branch
	git-autofetch $autofetch_options

	PS1=''

	# Display username and hostname only when connected via SSH
	if [[ -v SSH_CLIENT ]]; then
		PS1+=' ‹%F{green}%n %F{cyan}%m%F{default}›'
	fi

	# Current directory
	PS1+=' %F{blue}%~'

	# Python virtual environment
	if [[ -v VIRTUAL_ENV ]]; then
		PS1+=" %F{default}⚕"
	fi

	# Last command's error status
	PS1+='%(?..%F{red} %?)'

	# Git status
	SED_PATTERN='s/^/ %F{yellow}/;'                                                                    # Yellow
	SED_PATTERN+='s/[0-9]*↑/%F{green}&/;s/[0-9]*↓/%F{yellow}&/;s/⮁/%F{default}&/;s/×/%F{red}&/' # Ahead-after
	PS1+="$(git-data --status | sed "$SED_PATTERN")"

	# Root or normal user?
	PS1+=' %F{default}%(!.%F{red}⮕.→)'

	# Reset color and final prompt
	PS1+='%F{default} '
}
