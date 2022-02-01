# dotfiles

Config files for my computers.
This repository also contains various aliases and scripts to automate many tasks.

You can find a non-exhaustive list of added commands for Git [here](git-aliases.md).

## Installation

By default, this repository expects to be cloned in `~/config`.

```shell
git clone https://gitlab.com/clovis-ai/dotfiles.git ~/config
```

If you want to clone it elsewhere, you can set the following environment variable (if you decide to do so, do replace the path in all other examples in this file as well):

```shell
export CLOVIS_CONFIG="the path where you cloned it"
```

### Bash and Zsh

The configuration is done via the `selector` script, either `selector.sh` for Bash, or `selector.zsh` for Zsh.

This guide assumes you want to activate *everything* this project brings. If you don't (eg. you don't want the prompts), run the following commands to see what the options are:

```shell
source ~/config/selector.sh --help
```

If you will only use the project the 'easy way' (not via SSH, and without calling programs from outside the shell), you can init it like this:

```shell
# If you use Bash, in ~/.bashrc
source ~/config/selector.sh

# If you use Zsh, in ~/.zshrc
source ~/config/selector.zsh
```

If you intend to use these tools via SSH or other systems, you will need to differentiate between login shells and regular shells:

```bash
# Configuration for Bash

# In ~/.bash_profile:
source ~/config/selector.sh --env-shell
# In ~/.bashrc:
source ~/config/selector.sh --no-env
```

```zsh
# Configuration for Zsh

# In ~/.zshenv:
source ~/config/selector.zsh --env-shell
# In ~/.zshrc:
source ~/config/selector.zsh --no-env
```

### Git

To get access to the Git configuration (including aliases and default merge strategies), add the following lines to your `~/.gitconfig`:

```
[include]
	path = ~/config/gitconfig
```
