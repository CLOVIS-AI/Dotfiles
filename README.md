# dotfiles

Config files for my computers.
This repository also contains various aliases and scripts to automate many tasks.

You can find a non-exhaustive list of added commands for Git [here](git-aliases.md).

## Installation

By default, this repository expects to be cloned in `~/config`.

    git clone git@gitlab.com:clovis-ai/dotfiles.git ~/config

If you want to clone it elsewhere, you can set the following environment variable (if you decide to do so, do replace the path in all other examples in this file as well):

    export CLOVIS_CONFIG="the path where you cloned it"

### Bash and Zsh

The configuration is done via the `selector` script, either `selector.sh` for Bash, or `selector.zsh` for Zsh.

This guide assumes you want to activate *everything* this project brings. If you don't (eg. you don't want the prompts), run the following commands to see what the options are:

    . ~/config/selector.sh --help

If you will only use the project the 'easy way' (not via SSH, and without calling programs from outside the shell), you can init it like this:

    # If you use Bash, in ~/.bashrc
    . ~/config/selector.sh

    # If you use Zsh, in ~/.zshrc
    . ~/config/selector.zsh

If you intend to use these tools via SSH or other systems, you will need to differentiate between login shells and regular shells:

    # Bash: in ~/.bash_profile
    . ~/config/selector.sh --login-shell
    # Bash: in ~/.bashrc
    . ~/config/selector.sh --after-login
    
    # Zsh: in ~/.zlogin
    . ~/config/selector.zsh --login-shell
    # Zsh: in ~/.zshrc
    . ~/config/selector.zsh --after-login

### Git

To get access to the Git configuration (including aliases and default merge strategies), add the following lines to your `~/.gitconfig`:

    [include]
        path = ~/config/gitconfig
