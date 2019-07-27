#!/bin/bash

THIS_DIR=$(cd $(dirname $0); pwd)
FILES_DIR=$THIS_DIR/files
TARGET_DIR=$HOME

cd $FILES_DIR

echo "start setup from $THIS_DIR"

find . -mindepth 1 -type d -exec mkdir -p $TARGET_DIR/{} \;
find . -mindepth 1 -type f -exec ln -snfv $FILES_DIR/{} $TARGET_DIR/{} \;

echo "dotfiles updated."
