# Source this file in your .zshrc

# vim like terminal
set -o vi
set editing-mode vi
set keymap vi

# Prompt customization
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/ \(\1\)/p'
}
setopt PROMPT_SUBST
export PROMPT='%F{cyan}%~%f%F{green}$(parse_git_branch)%f %F{normal}$%f '

alias tm="~/.config/nvim/tm.sh"

