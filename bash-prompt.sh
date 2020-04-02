parse_git_branch() {
    GIT_INFO="$(git data --ahead-after 2>/dev/null) "
    [[ $GIT_INFO == " " ]] && GIT_INFO=$(git data --current 2>/dev/null)

    echo "$GIT_INFO"
}

#export PS1="\[\033[48;5;16m\][ \[\033[94m\]\u@\h \[\033[32m\]\W \[\033[33m\]\$(parse_git_branch)
# \[\033[39m\]]\[\033[00m\] $ "

#export PS1="\[\e[32m\]『\u』\[\e[36m\]\h \[\e[34m\]\W \[\e[33m\]\$(parse_git_branch)\[\e[0m\]→ "

function generate_prompt() {
	local exit="$?"

	echo -e "\e[32m『$USER』\e[36m$HOSTNAME \e[34m${PWD##*/} \e[33m$(parse_git_branch)\e[0m→ "
}

export PS1="\$(generate_prompt)"
