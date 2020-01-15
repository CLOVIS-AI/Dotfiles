# dotfiles

Config files for my computers

## Installation

Clone the repository in `~/config`:

    git clone git@gitlab.com:clovis-ai/dotgiles.git ~/config

### .bashrc

Choose what you want, and add it to your `.bashrc`:

    . ~/config/bash-aliases # My custom aliases
    . ~/config/bash-prompt  # My custom prompt
    . ~/config/bash-path    # Adds the scripts in scripts/ to your path
    . ~/config/bashrc       # All of the above

### Git config

Add the following lines to your `.gitconfig`.

    [include]
        path = ~/config/gitconfig

### Using a different path than the default one

You can add the following environnement variable:

    export CLOVIS_CONFIG="the path you want to clone the repository to"

As much as possible of this config will honor this environnement variable, but, for example, the Git configuration doesn't (no support for environnement variables in configuration files). At the moment, the only thing you will be missing out is the user-wide Gitignore file. If you need it, either include it in your global `.gitconfig` file, or create a symlink from `~/config/gitignore` to the desired location.
