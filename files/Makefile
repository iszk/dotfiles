
.PHONY: install-brew
install-brew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	# 実際にちゃんと動くか確認してない

.PHONY: install-asdf
install-asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0
	. ~/.asdf/asdf.sh
	asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
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
