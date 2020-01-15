#
# .bashrc
#

CONFIG=${CLOVIS_CONFIG:-$HOME/config}

# Custom bash prompt
. $CONFIG/bash-prompt

# Aliases
. $CONFIG/bash-aliases

# Adding the scripts to the path
. $CONFIG/bash-path