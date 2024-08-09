#!/bin/bash

make sync

if [ "$DEVCONTAINER" == "true" ]; then
    echo "Running in a devcontainer. Executing devcontainer-specific commands."
    echo "home = $HOME"
    echo "user = $USER"
fi
