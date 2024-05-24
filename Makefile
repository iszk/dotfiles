THIS_DIR := $(shell pwd)
FILES_DIR := $(THIS_DIR)/files
TARGET_DIR := $(HOME)

.PHONY: sync create_dirs link_files set_permissions

sync: create_dirs link_files set_permissions

create_dirs:
	cd $(FILES_DIR) && find . -mindepth 1 -type d -exec mkdir -p $(TARGET_DIR)/{} \;

link_files:
	cd $(FILES_DIR) && find -mindepth 1 -type f -exec ln -snfv $(FILES_DIR)/{} $(TARGET_DIR)/{} \;

set_permissions:
	@echo "Setting permissions..."
	@chmod -R go-rwx $(TARGET_DIR)/.ssh

.PHONY: install-tools
install-tools:
	echc 'yet'
	# ghq
	# fzf
	# rg
	# task
