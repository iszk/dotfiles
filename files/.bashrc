# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

export SHELL=$(which bash)

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

## History
# Make bash append rather than overwrite the history on disk
shopt -s histappend
# Do not the results of history substitution immediately pass to the shell parser.
shopt -s histverify
# multi-line commands are saved to the history with embedded newlines rather than using semicolon separators where possible.
shopt -s lithist
# Don't put duplicate lines or lines starting with space in the history. See
HISTCONTROL="ignoreboth"
# change ~/.bash_history
HISTFILE="$XDG_STATE_HOME/bash_history"
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

function command_exists() {
    if command -v "$1" &> /dev/null; then
        return 0
    fi
    return 255
}

function file_exists {
    if [ -e "$1" ]; then
        return 0
    fi
    return 255
}

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

files=(
    "${XDG_DATA_HOME}/git/git-prompt.sh"
    "${XDG_DATA_HOME}/git/git-completion.bash"
    "${XDG_DATA_HOME}/task/task.bash"
)

for file in "${files[@]}"
do
    # ファイルが存在するか確認
    if file_exists "$file"; then
        source "$file"
    else
        echo "File: $file does not exist."
    fi
done


# 現在のブランチがupstreamより進んでいるとき">"を、遅れているとき"<"を、遅れてるけど独自の変更もあるとき"<>"を表示する
GIT_PS1_SHOWUPSTREAM=1
# addされてない新規ファイルがある(untracked)とき"%"を表示する
GIT_PS1_SHOWUNTRACKEDFILES=1
# stashになにか入っている(stashed)とき"$"を表示する
# GIT_PS1_SHOWSTASHSTATE=1
# addされてない変更(unstaged)があったとき"*"を表示する、addされているがcommitされていない変更(staged)があったとき"+"を表示する
GIT_PS1_SHOWDIRTYSTATE=1

# prompt
if command_exists __git_ps1; then
    if [ "$REMOTE_CONTAINERS" ]; then
        export PS1='\[\e[34m\]\u \[\e[31m\]>\[\e[0m\] \W\[\e[31m\]$(__git_ps1)\[\e[0m\]\$ '
    else
        export PS1='\[\e[31m\]>\[\e[0m\] \w\[\e[31m\]$(__git_ps1)\[\e[0m\]\n\t \[\e[34m\]\u@\h\[\e[0m\] \$ '
    fi
else
    export PS1='\[\e[31m\]>\[\e[0m\] \w\[\e[0m\]\n\t \[\e[34m\]\u@\h\[\e[0m\] \$ '
fi

# 標準的なコマンドのオプション
DIFF_OPTIONS="-u --color"

case "$OSTYPE" in
    darwin*)
        if command -v brew > /dev/null; then
            if [[ -x $(brew --prefix)/bin/diff ]]; then
                alias diff="$(brew --prefix)/bin/diff $DIFF_OPTIONS"
            fi
        fi
        LS_OPTIONS="-FG"
    ;;
    linux*)
        LS_OPTIONS="-hFv --time-style=long-iso --group-directories-first --color=auto"
    ;;
esac

alias ls="ls $LS_OPTIONS"
alias diff="diff $DIFF_OPTIONS"
alias relogin='exec $SHELL -l'
# シェルの再起動(source .zshrc より良い、unalias相当のこともできるので)

# go
if command_exists go; then
    export PATH="$(go env GOPATH)/bin:$PATH"
fi

# fzf version 0.48 以降
if command_exists fzf; then
    eval "$(fzf --bash)"
    export FZF_DEFAULT_OPTS='--bind ctrl-space:preview-half-page-down --color light'
fi

# direnv
if command_exists direnv; then
    eval "$(direnv hook bash)"
fi

# 普通の alias
if command_exists poetry; then
    alias pr='poetry run'
    alias pp='poetry run python'
fi

gq() {
    if command_exists ghq; then
        local dir
        dir=$(ghq list | fzf --reverse +m --prompt 'select repository >')
        if [[ -n "$dir" ]]; then
            cd $(ghq root)/$dir
        fi
    else
        echo "ghq command not found."
    fi
}

# 実用的 alias
alias ga="git-fzf add"

# あまり使わないけどコマンドを忘れたときに見るための alias
alias ssh-fingerprint="ssh-keygen -lf"
