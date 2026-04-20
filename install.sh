#!/bin/bash

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
FILES_DIR="$THIS_DIR/files"
TARGET_DIR="$HOME"

create_dirs() {
    cd "$FILES_DIR" && find . -mindepth 1 -type d -exec mkdir -p "$TARGET_DIR/{}" \;
}

link_files() {
    cd "$FILES_DIR" && find . -mindepth 1 -type f -exec ln -snfv "$FILES_DIR/{}" "$TARGET_DIR/{}" \;
}

set_permissions() {
    chmod -R go-rwx "$TARGET_DIR/.ssh"
}

create_dirs
link_files
set_permissions
