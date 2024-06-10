#!/bin/bash

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

## set PATH so it includes user's private bin if it exists
## 標準の .profile でやってくれそうなのでここではやらない
#for private_dir in "$HOME/.local/bin" "$HOME/bin"; do
#    if [ -d "$private_dir" ] ; then
#        PATH="$private_dir:$PATH"
#        break
#    fi
#done
#unset private_dir

source .bashrc
