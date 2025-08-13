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

.PHONY: install-tools install-go-task install-fzf
install-tools: install-go-task install-fzf

.ONESHELL:
install-go-task:
	@echo "Installing go-task..."
	if ! command -v task > /dev/null; then
		curl --location https://taskfile.dev/install.sh | sh -s -- -d -b ~/.local/bin
		@echo "go-task installed successfully."
	else
		@echo "go-task is already installed."
	fi

install-fzf:
	@echo "Installing fzf..."
	if ! command -v fzf > /dev/null; then
		git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
		~/.fzf/install --bin
		ln -s ~/.fzf/bin/fzf $(HOME)/.local/bin/fzf
		@echo "fzf installed successfully."
	else
		@echo "fzf is already installed."
	fi


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

.PHONY: fix-git-remote-url
.ONESHELL:
fix-git-remote-url:
	@echo "Checking current remote URL for 'origin'..."
	@REMOTE_URL_HTTPS=$$(git remote get-url origin)
	@if echo "$$REMOTE_URL_HTTPS" | grep -q "^https"; then
		echo "Current remote URL is HTTPS: $$REMOTE_URL_HTTPS"
		# Extract username and repository from the HTTPS URL
		# e.g., https://github.com/username/repository.git -> username/repository
		REPO_PATH=$$(echo "$$REMOTE_URL_HTTPS" | sed -E 's/https:\/\/github\.com\/(.*)\.git/\1/')
		# Construct the new SSH URL
		REMOTE_URL_SSH="git@github.com:$$REPO_PATH.git"
		echo "Changing remote URL to SSH: $$REMOTE_URL_SSH"
		# Execute the git command to change the URL
		git remote set-url origin "$$REMOTE_URL_SSH"
		echo "Remote URL has been successfully changed."
		echo "Verifying the new URL..."
		git remote -v
	else
		echo "Current remote URL is not in HTTPS format. No change needed."
		git remote -v
	fi
