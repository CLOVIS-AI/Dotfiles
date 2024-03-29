#!/usr/bin/env bash

if [[ $1 == "--help" || $1 == "help" ]]; then
	cat <<EOF
Selector.sh · CLOVIS-AI

Description:
    This script can be used to load various parts of my configuration.
    It can be parameterized via command-line options, or via environment variables.

    This script is intended to be sourced in one's .bashrc file.

Usages:
    . selector.sh --help
    . selector.sh [options]

Options:
	Any option overrides previous options.
    -v, --verbose           Display information about what the script does
    --no-bash-aliases       Do not source the bash aliases
    --no-bash-prompt        Do not source the bash prompt
    --no-scripts            Do not add the customized scripts to the PATH variable
    --no-packager           Do not add the packager scripts to the PATH variable
    --no-probe              Do not add the probe scripts to the PATH variable
    --no-completion         Do not add bash completion
    --no-autofetch          Do not auto-fetch git repositories
    --no-autofetch-config   Do not auto-fetch the configuration repository
    --env-shell             Specify session-wide values (PATH...)
    --no-env                Specify everything that is NOT specified in --env-shell
    --no-opensavvy          Do not enable the OpenSavvy dotfiles (required by Packager)

Environment variables:
    CLOVIS_CONFIG_ALIASES   Source the Bash aliases (default: yes)
    CLOVIS_CONFIG_PROMPT    Source the Bash prompt (default: yes)
    CLOVIS_CONFIG_SCRIPTS   Add the scripts to the PATH (default: yes)
    CLOVIS_CONFIG_PACKAGER  Add the packager scripts to the PATH (default: yes)
    CLOVIS_CONFIG_PROBE     Add the probe scripts to the PATH (default: yes)
    CLOVIS_CONFIG_COMPLETE  Sets up bash completion (default: yes)
    CLOVIS_CONFIG_AUTOFETCH Autofetches git repositories when entering them (default: yes)
    CLOVIS_CONFIG_AFCONFIG  Autofetches the configuration repository (default: yes)
    CLOVIS_CONFIG_OPENSAVVY Enables the OpenSavvy dotfiles (required for Packager, default: yes)
EOF
fi

CLOVIS_CONFIG_VERBOSE=0

function debug() {
	if [[ $CLOVIS_CONFIG_VERBOSE == 1 ]]; then
		echo -e "$*"
	fi
}

################# Parse Arguments ##################

while [[ $# -gt 0 ]]; do
	debug "Argument: $1"
	case $1 in
	-v | --verbose)
		CLOVIS_CONFIG_VERBOSE=1
		;;
	--no-bash-aliases)
		CLOVIS_CONFIG_ALIASES=no
		;;
	--no-bash-prompt)
		CLOVIS_CONFIG_PROMPT=no
		;;
	--no-scripts)
		CLOVIS_CONFIG_SCRIPTS=no
		;;
	--no-packager)
		CLOVIS_CONFIG_PACKAGER=no
		;;
	--no-probe)
		CLOVIS_CONFIG_PROBE=no
		;;
	--no-completion)
		CLOVIS_CONFIG_COMPLETE=no
		;;
	--no-autofetch)
		CLOVIS_CONFIG_AUTOFETCH=no
		;;
	--no-autofetch-config)
		CLOVIS_CONFIG_AFCONFIG=no
		;;
	--no-opensavvy)
		CLOVIS_CONFIG_OPENSAVVY=no
		CLOVIS_CONFIG_PACKAGER=no
		;;
	--env-shell)
		CLOVIS_CONFIG_ALIASES=no
		CLOVIS_CONFIG_PROMPT=no
		CLOVIS_CONFIG_SCRIPTS=yes
		CLOVIS_CONFIG_PACKAGER=yes
		CLOVIS_CONFIG_PROBE=yes
		CLOVIS_CONFIG_AUTOFETCH=no
		CLOVIS_CONFIG_AFCONFIG=no
		CLOVIS_CONFIG_COMPLETE=no
		CLOVIS_CONFIG_OPENSAVVY=yes
		;;
	--no-env)
		CLOVIS_CONFIG_ALIASES=yes
		CLOVIS_CONFIG_PROMPT=yes
		CLOVIS_CONFIG_SCRIPTS=no
		CLOVIS_CONFIG_PACKAGER=no
		CLOVIS_CONFIG_PROBE=no
		CLOVIS_CONFIG_AUTOFETCH=yes
		CLOVIS_CONFIG_AFCONFIG=yes
		CLOVIS_CONFIG_COMPLETE=yes
		CLOVIS_CONFIG_OPENSAVVY=no
		;;
	esac
	shift
done

################# Finding the config ###############

CLOVIS_CONFIG=${CLOVIS_CONFIG:-~/config}
debug "The configuration should be in: $CLOVIS_CONFIG"

################# Source scripts ###################

if [[ ${CLOVIS_CONFIG_ALIASES:-yes} == yes ]]; then
	debug "Sourcing the Bash aliases..."

	# shellcheck source=bash-aliases
	. "$CLOVIS_CONFIG"/bash-aliases
fi

if [[ ${CLOVIS_CONFIG_PROMPT:-yes} == yes ]]; then
	debug "Sourcing the Bash prompt..."

	# shellcheck source=bash-prompt.sh
	. "$CLOVIS_CONFIG"/bash-prompt.sh
fi

if [[ ${CLOVIS_CONFIG_SCRIPTS:-yes} == yes ]]; then
	debug "Adding the scripts to the PATH variable..."

	if [[ $PATH != *"$CLOVIS_CONFIG/scripts"* ]]; then
		PATH="$PATH:$CLOVIS_CONFIG/scripts"
	fi
fi

if [[ ${CLOVIS_CONFIG_OPENSAVVY:-yes} == yes ]]; then
	debug "Configuring the OpenSavvy Dotfiles..."

	here=$(pwd)
	cd "$CLOVIS_CONFIG/opensavvy"
	if [ -n "$ZSH_VERSION" ]; then
	  source ./os_configure.zsh
	else
	  source ./os_configure.bash
	fi
	cd "$here"
fi

if [[ ${CLOVIS_CONFIG_PACKAGER:-yes} == yes ]]; then
	debug "Adding the packager system to the PATH variable..."

	if [[ $PATH != *"$CLOVIS_CONFIG/packager"* ]]; then
		PATH="$PATH:$CLOVIS_CONFIG/packager/src"
	fi
fi

if [[ ${CLOVIS_CONFIG_PROBE:-yes} == yes ]]; then
	debug "Adding the probe system to the PATH variable..."

	if [[ $PATH != *"$CLOVIS_CONFIG/probe"* ]]; then
		PATH="$PATH:$CLOVIS_CONFIG/probe"
	fi
fi

if [[ ${CLOVIS_CONFIG_COMPLETE:-yes} == yes ]]; then
	debug "Sourcing bash completion for the different commands..."

	# shellcheck source=scripts/announce
	. "$CLOVIS_CONFIG"/scripts/announce complete
fi

if [[ ${CLOVIS_CONFIG_AUTOFETCH:-yes} == yes ]]; then
	debug "Setting up git autofetch..."

	export PROMPT_COMMAND
	if [[ "$PROMPT_COMMAND" == "" ]]; then
		PROMPT_COMMAND="git autofetch"
	else
		PROMPT_COMMAND="$PROMPT_COMMAND; git autofetch"
	fi
fi

if [[ ${CLOVIS_CONFIG_AFCONFIG:-yes} == yes ]]; then
	debug "Autofetching the configuration repository..."

	here=$(pwd)
	cd "$CLOVIS_CONFIG"
	git autofetch
	cd "$here"
fi

unset CLOVIS_CONFIG_ALIASES CLOVIS_CONFIG_PROMPT CLOVIS_CONFIG_SCRIPTS CLOVIS_CONFIG_PACKAGER CLOVIS_CONFIG_PROBE CLOVIS_CONFIG_COMPLETE CLOVIS_CONFIG_AUTOFETCH CLOVIS_CONFIG_AFCONFIG CLOVIS_CONFIG_OPENSAVVY
