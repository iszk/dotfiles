#!/bin/bash

THIS_DIR=$(cd $(dirname $0); pwd)
FILES_DIR=$THIS_DIR/files
TARGET_DIR=$HOME

cd $FILES_DIR

echo "start setup from $THIS_DIR"

find . -mindepth 1 -type d -exec mkdir -p $TARGET_DIR/{} \;
find . -mindepth 1 -type f -exec ln -snfv $FILES_DIR/{} $TARGET_DIR/{} \;

chmod -R g-rwx $TARGET_DIR/.ssh
chmod -R o-rwx $TARGET_DIR/.ssh

echo "dotfiles updated."

# awscli
# https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-linux.html
