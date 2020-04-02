parse_git_branch() {
    GIT_INFO="$(git data --ahead-after 2>/dev/null) "
    [[ $GIT_INFO == " " ]] && GIT_INFO=$(git data --current 2>/dev/null)

    echo "$GIT_INFO"
}

function generate_prompt() {
	local exit="$?"

	if [[ $SSH_CLIENT != "" ]];
	then
		echo -en " ‹\e[32m$USER \e[36m$HOSTNAME\e[0m›"
	fi

	echo -e " \e[34m${PWD##*/} \e[33m$(parse_git_branch)\e[0m→ "
}

export PS1="\$(generate_prompt)"
