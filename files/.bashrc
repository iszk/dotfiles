# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# history settings
## ignorespace 空白で始まる場合は保存しない
## erasedups 同じものが来たら過去のものを削除する
HISTCONTROL=erasedups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000
## マッチしたものは保存しない
HISTIGNORE=cd:ls:pwd:history:which*

# append to the history file, don't overwrite it
shopt -s histappend


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# git prompt
if [ -f ~/.git-prompt.sh ]; then
    . ~/.git-prompt.sh
fi

# for homebrew m1 mac
if type "/opt/homebrew/bin/brew" > /dev/null 2>&1
then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Homebrew Completions
if type "brew" > /dev/null 2>&1
then 
    BREW_SCRIPTS="$(brew --prefix)/etc/bash_completion.d"
    if [ -d "$BREW_SCRIPTS" ]; then for script in $(find $BREW_SCRIPTS -type l) ; do . $script ; done fi
fi

function prompt_setting {
    case $TERM in
        xterm*) TITLEBAR='\[\e]0;\$ \w@\h\007\]';;
        *)      TITLEBAR="";;
    esac
    if type "git" > /dev/null 2>&1
    then
        GIT_PS1_SHOWDIRTYSTATE=true
        GITBRANCH='\[\033[34m\]$(__git_ps1)\[\033[00m\]'
    else
        GITBRANCH=""
    fi
    local PRMPT='\t \u@\h:\w'
    PS1="${TITLEBAR}${PRMPT}${GITBRANCH}\$ "
}
prompt_setting

export TZ=Asia/Tokyo

# asdf
if type "$HOME/.asdf/bin/asdf" > /dev/null 2>&1
then
    . $HOME/.asdf/asdf.sh
    . $HOME/.asdf/completions/asdf.bash
fi

# asdf-direnv
if type "$HOME/.asdf/shims/direnv" > /dev/null 2>&1
then
    eval "$(asdf exec direnv hook bash)"
    # A shortcut for asdf managed direnv.
    direnv() { asdf exec direnv "$@"; }
elif type "direnv" > /dev/null 2>&1
then
    # asdf ではなく direnv が入っている場合
    eval "$(direnv hook bash)"
fi

# asdf go-sdk
if type "go" > /dev/null 2>&1
then
    export PATH="$(go env GOPATH)/bin:$PATH"
fi

export PATH="$HOME/bin:$PATH"

# fzf settings
if [ -f ~/.bash_fzf ]; then
    . ~/.bash_fzf
fi

# local settings
if [ -f ~/.bash_local ]; then
    . ~/.bash_local
fi

export PERL5LIB=$HOME/perl5/lib/perl5:$PERL5LIB;

