#!/usr/bin/env bash

if [[ $1 = "--help" || $1 == "help" ]]
then
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
    -v, --verbose           Display information about what the script does
    --no-bash-aliases       Do not source the bash aliases
    --no-bash-prompt        Do not source the bash prompt
    --no-scripts            Do not add the customized scripts to the PATH variable
    --no-completion         Do not add bash completion

Environment variables:
    CLOVIS_CONFIG_ALIASES   Source the Bash aliases (default: yes)
    CLOVIS_CONFIG_PROMPT    Source the Bash prompt (default: yes)
    CLOVIS_CONFIG_SCRIPTS   Add the scripts to the PATH (default: yes)
    CLOVIS_CONFIG_COMPLETE  Sets up bash completion
EOF
fi

CLOVIS_CONFIG_VERBOSE=0

function debug {
    if [[ $CLOVIS_CONFIG_VERBOSE == 1 ]]
    then
        echo -e "$*"
    fi
}

################# Parse Arguments ##################

while [[ $# -gt 0 ]]
do
    debug "Argument: $1"
    case $1 in
    -v|--verbose)
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
    --no-completion)
        CLOVIS_CONFIG_COMPLETE=no
        ;;
    esac
    shift
done

################# Finding the config ###############

CLOVIS_CONFIG=${CLOVIS_CONFIG:-~/config}
debug "The configuration should be in: $CLOVIS_CONFIG"

################# Source scripts ###################

if [[ ${CLOVIS_CONFIG_ALIASES:-yes} == yes ]]
then
    debug "Sourcing the Bash aliases..."

    # shellcheck source=bash-aliases
    . "$CLOVIS_CONFIG"/bash-aliases
fi

if [[ ${CLOVIS_CONFIG_PROMPT:-yes} == yes ]]
then
    debug "Sourcing the Bash prompt..."

    # shellcheck source=bash-prompt
    . "$CLOVIS_CONFIG"/bash-prompt
fi

if [[ ${CLOVIS_CONFIG_SCRIPTS:-yes} == yes ]]
then
    debug "Adding the scripts to the PATH variable..."

    # shellcheck source=bash-path
    . "$CLOVIS_CONFIG"/bash-path
fi

if [[ ${CLOVIS_CONFIG_COMPLETE:-yes} == yes ]]
then
    debug "Sourcing bash completion for the different commands..."

    # shellcheck source=scripts/packager
    . "$CLOVIS_CONFIG"/scripts/packager complete

    # shellcheck source=scripts/announce
    . "$CLOVIS_CONFIG"/scripts/announce complete

fi