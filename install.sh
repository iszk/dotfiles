#!/bin/bash

make sync

if [ "$REMOTE_CONTAINERS" == "true" ]; then
    echo "Running in a devcontainer. Executing devcontainer-specific commands."
    echo "EXTOOLS_SOURCE_DIR = $EXTOOLS_SOURCE_DIR"
    echo "EXTOOLS_TARGET_DIR = $EXTOOLS_TARGET_DIR"
    if [ -n "${EXTOOLS_SOURCE_DIR}" ]; then
        /bin/bash $EXTOOLS_SOURCE_DIR/install.sh
        if [ -n "${EXTOOLS_TARGET_DIR}" ]; then
            ln -s $EXTOOLS_SOURCE_DIR $EXTOOLS_TARGET_DIR
        fi
    fi
fi
