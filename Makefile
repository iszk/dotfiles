
.PHONY: install-brew
install-brew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	# 実際にちゃんと動くか確認してない

.PHONY: install-mac
	brew install go

	# gnu tools
	brew install coreutils findutils gnu-sed grep
	brew install diffutils

.PHONY: install-asdf
install-asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
	. ~/.asdf/asdf.sh
	# for 文で書き直したい
	asdf plugin add nodejs
	asdf plugin-add go-sdk
	asdf plugin-add python
	asdf plugin-add direnv
	asdf plugin add perl
	asdf install nodejs latest
	asdf install go-sdk latest
	asdf install python latest
	asdf install direnv latest
	asdf global nodejs latest
	asdf global go-sdk latest
	asdf global python latest
	asdf global direnv latest
	# go-sdk を利用するのには go が必要なので、別途 homebrew 等でインストールしておく必要がある

.PHONY: install-tools
install-tools:
	go install github.com/junegunn/fzf@latest
	go install github.com/go-task/task/v3/cmd/task@latest
	# task の completion をコピーする
	# cp ~/go/pkg/mod/github.com/go-task/task/v3@v3.28.0/completion/zsh/_task ~/.zsh_completion
