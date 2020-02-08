# dotfiles

Config files for my computers

## Installation

Clone the repository in `~/config`:

    git clone git@gitlab.com:clovis-ai/dotgiles.git ~/config

### .bashrc

To activate the configuration, add this line to your `.bashrc` or similar file:

    . ~/config/selector.sh

It is possible to select which features are activated or not by default. To know what you can do, type:

    . ~/config/selector.sh --help

### Git config

Add the following lines to your `.gitconfig`.

    [include]
        path = ~/config/gitconfig

### Using a different path than the default one

You can add the following environnement variable:

    export CLOVIS_CONFIG="the path you want to clone the repository to"

As much as possible of this config will honor this environnement variable, but, for example, the Git configuration doesn't (no support for environnement variables in configuration files). At the moment, the only thing you will be missing out is the user-wide Gitignore file. If you need it, either include it in your global `.gitconfig` file, or create a symlink from `~/config/gitignore` to the desired location.
