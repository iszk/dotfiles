
export SHELL=`which zsh`

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
zstyle ':vcs_info:git:*' stagedstr "*"
zstyle ':vcs_info:git:*' unstagedstr "+"
zstyle ':vcs_info:*' formats "%F{red}(%b%u%c)%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

# prompt
if [ "$REMOTE_CONTAINERS" ]; then
    PROMPT='%F{blue}%n%f %B%F{red}>%f%b %~ '\$vcs_info_msg_0_$'%# '
else
    PROMPT='%B%F{red}> %f%b%~ '\$vcs_info_msg_0_$'\n''%* %F{blue}%n@%m%f %# '
fi

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
    COMPLETION=""
    # ファイルが存在する場合、fpath に追加する
    for f (
        "/opt/homebrew/Cellar/go-task/3.35.1/share/zsh/site-functions/_task"
        "/usr/local/lib/task/completion/zsh/_task"
    ) {
        if test -f $f; then
            COMPLETION=$f
            break
        fi
    }

    if "$COMPLETION"  ""; then
        fpath=($COMPLETION $fpath)
    fi
fi

# direnv
if command -v direnv > /dev/null; then
    eval "$(direnv hook zsh)"
fi

# fzf
# version 0.48 以降はこっち
if command -v fzf > /dev/null; then
    source <(fzf --zsh)
fi
# C-r で history をインクリメンタルサーチできるように
# function select-history() {
#    BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
#    CURSOR=$#BUFFER
# }
# zle -N select-history
# bindkey '^r' select-history

# mise
if command -v mise > /dev/null; then
    eval "$(mise activate zsh)"
fi

# 補完をONにする
autoload -Uz compinit && compinit

# 普通の alias
if command -v poetry > /dev/null; then
    alias pr='poetry run'
    alias pp='poetry run python'
fi

alias relogin='exec $SHELL -l'
# シェルの再起動(source .zshrc より良い、unalias相当のこともできるので)

gq() {
    local dir
    dir=$(ghq list | fzf --reverse +m --prompt 'select repository >')
    cd $(ghq root)/$dir
}

task() {
    if [ -z "$1" ]; then
        command task --list-all | tail +2 | fzf --reverse --prompt 'task: Available tasks for this project:' | awk '{ print $2 }' | sed 's/:$//' | xargs task
    else
        command task "$@"
    fi
}
