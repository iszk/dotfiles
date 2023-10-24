

## 個人のスクリプトは XDG 的に ~/.local/bin/ に入れる
export PATH=$PATH:$HOME/.local/bin

# 補完機能
ADD_FPATH_DIR=~/.zsh_completion
if [[ -d $ADD_FPATH_DIR ]]; then
    # fpath+=($TARGET_DIR)
    fpath=($ADD_FPATH_DIR  "${fpath[@]}" )
fi
autoload -Uz compinit && compinit

# prompt に git 周りの情報を表示するため
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "!"
zstyle ':vcs_info:git:*' unstagedstr "+"
zstyle ':vcs_info:*' formats "%F{blue}(%b%c%u)%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

# prompt
PROMPT='%B%F{red}> %f%b%~ '\$vcs_info_msg_0_$'\n''%F{444}%* %n@%m%f %# '

# ls
LS_OPTIONS="-hFv --time-style=long-iso --group-directories-first --color=auto"
alias ls="ls $LS_OPTIONS"

# diff
DIFF_OPTIONS="-u --color"
alias diff="diff $DIFF_OPTIONS"

# mac で GNU の各種コマンドが起動するように
case "$OSTYPE" in
    darwin*)
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
        if [[ -x $(brew --prefix)/bin/diff ]]; then
            alias diff="$(brew --prefix)/bin/diff $DIFF_OPTIONS"
        fi
    ;;
esac

