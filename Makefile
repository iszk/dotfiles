THIS_DIR := $(shell pwd)
FILES_DIR := $(THIS_DIR)/files
TARGET_DIR := $(HOME)
XDG_DATA_HOME := $(HOME)/.local/share

# ダウンロードするファイルを、"URL 保存先ファイル名" の形式で指定
DOWNLOAD_FILES := "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh : $(XDG_DATA_HOME)/git/git-prompt.sh"
DOWNLOAD_FILES += "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash : $(XDG_DATA_HOME)/git/git-completion.bash"
DOWNLOAD_FILES += "https://raw.githubusercontent.com/go-task/task/main/completion/bash/task.bash : $(XDG_DATA_HOME)/task/task.bash"

.PHONY: sync create_dirs link_files set_permissions

sync: create_dirs link_files set_permissions setup-tools

create_dirs:
	cd $(FILES_DIR) && find . -mindepth 1 -type d -exec mkdir -p $(TARGET_DIR)/{} \;

link_files:
	cd $(FILES_DIR) && find . -mindepth 1 -type f -exec ln -snfv $(FILES_DIR)/{} $(TARGET_DIR)/{} \;

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
	# peco

.PHONY: setup-tools download_files
setup-tools: download_files

download_files:
	@echo "Downloading files..."
	@for pair in $(DOWNLOAD_FILES); do \
		url=$${pair%% : *}; \
		file=$${pair##* : }; \
		echo "Checking $$file..."; \
		if [ ! -f $$file ]; then \
			echo "Downloading $$file from $$url..."; \
			curl $$url -o $$file --create-dirs; \
		fi \
	done

