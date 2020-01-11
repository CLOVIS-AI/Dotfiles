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
