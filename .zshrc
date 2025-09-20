# Source this file in your .zshrc or .bashrc

# vim like terminal
set -o vi
set editing-mode vi
set keymap vi

# Prompt customization
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/ \(\1\)/p'
}
if [[ "$(uname)" == "Darwin" ]]; then
    setopt PROMPT_SUBST
    export PROMPT='%F{cyan}%~%f%F{green}$(parse_git_branch)%f %F{normal}$%f '
fi

alias tm="~/.config/nvim/tm.sh"

export VISUAL=nvim
export EDITOR=vi

