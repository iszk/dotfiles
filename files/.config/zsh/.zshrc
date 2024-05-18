
# Ctrl+Dでログアウトしてしまうことを防ぐ
setopt IGNOREEOF

## 個人のスクリプトは XDG 的に ~/.local/bin/ に入れる
export PATH=$PATH:$HOME/.local/bin

## history関連
# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups
# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
# 余分な空白は詰めて記録
setopt hist_reduce_blanks
# 古いコマンドと同じものは無視
setopt hist_save_no_dups
# historyコマンドは履歴に登録しない
setopt hist_no_store
# 補完時にヒストリを自動的に展開
setopt hist_expand
setopt share_history
# historyを保管するファイルを指定
# このファイルがないことがあるので注意
HISTFILE=$XDG_CACHE_HOME/zsh/history
HISTSIZE=200000
SAVEHIST=200000


# prompt に git 周りの情報を表示するため
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "+"
zstyle ':vcs_info:git:*' unstagedstr "*"
zstyle ':vcs_info:*' formats "%F{blue}(%b%u%c)%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

# prompt
PROMPT='%B%F{red}> %f%b%~ '\$vcs_info_msg_0_$'\n''%F{444}%* %n@%m%f %# '

# 標準的なコマンドのオプション
LS_OPTIONS="-hFv --time-style=long-iso --group-directories-first --color=auto"
DIFF_OPTIONS="-u --color"

case "$OSTYPE" in
    darwin*)
        # mac で GNU の各種コマンドが起動するように
        (( ${+commands[gdate]} )) && alias date='gdate'
        (( ${+commands[gls]} )) && alias ls="gls $LS_OPTIONS"
        (( ${+commands[gmkdir]} )) && alias mkdir='gmkdir'
        (( ${+commands[gcp]} )) && alias cp='gcp'
        (( ${+commands[gmv]} )) && alias mv='gmv'
        (( ${+commands[grm]} )) && alias rm='grm'
        (( ${+commands[gdu]} )) && alias du='gdu'
        (( ${+commands[ghead]} )) && alias head='ghead'
        (( ${+commands[gtail]} )) && alias tail='gtail'
        (( ${+commands[gsed]} )) && alias sed='gsed'
        (( ${+commands[ggrep]} )) && alias grep='ggrep'
        (( ${+commands[gfind]} )) && alias find='gfind'
        (( ${+commands[gdirname]} )) && alias dirname='gdirname'
        (( ${+commands[gxargs]} )) && alias xargs='gxargs'
        if command -v brew > /dev/null; then
            if [[ -x $(brew --prefix)/bin/diff ]]; then
                alias diff="$(brew --prefix)/bin/diff $DIFF_OPTIONS"
            fi
        fi
    ;;
    linux*)
        alias ls="ls $LS_OPTIONS"
        alias diff="diff $DIFF_OPTIONS"
    ;;
esac

# go
if command -v go > /dev/null; then
    export PATH="$(go env GOPATH)/bin:$PATH"
fi

# go-task
if command -v task > /dev/null; then
    export PATH="$(go env GOPATH)/bin:$PATH"
    COMPLETION="$(go env GOPATH)/pkg/mod/github.com/go-task/task/v3@$(task --version | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+')/completion/zsh"
    fpath=($COMPLETION $fpath)
fi

# direnv
if command -v direnv > /dev/null; then
    eval "$(direnv hook zsh)"
fi

# fzf
if command -v fzf > /dev/null; then
    source <(fzf --zsh)
fi

# mise
if command -v mise > /dev/null; then
    eval "$(mise activate zsh)"
fi

# 補完をONにする
autoload -Uz compinit && compinit

# 普通の alias
alias pr='poetry run'
alias pp='poetry run python'

alias relogin='exec $SHELL -l'
# シェルの再起動(source .zshrc より良い、unalias相当のこともできるので)

gq() {
    local dir
    dir=$(ghq list | fzf --reverse +m --prompt 'select repository >')
    cd $(ghq root)/$dir
}
