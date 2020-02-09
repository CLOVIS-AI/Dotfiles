#
# .bashrc
#

echo "Warning. This script has been deprecated in favor of selector.sh. It may be removed in the future."

CONFIG=${CLOVIS_CONFIG:-$HOME/config}

# Custom bash prompt
. $CONFIG/bash-prompt

# Aliases
. $CONFIG/bash-aliases

# Adding the scripts to the path
. $CONFIG/bash-path