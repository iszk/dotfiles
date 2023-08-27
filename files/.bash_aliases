# bash aliases

case "${OSTYPE}" in
darwin*)
  alias ls="ls -GF"
  ;;
linux*)
  alias ls='ls -F --color=auto'
  ;;
esac

# git like diff
alias diff='diff -u'

# use poetry
alias pr='poetry run'
alias pp='poetry run python'

