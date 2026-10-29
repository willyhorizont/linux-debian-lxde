# -- willyhorizont.github.io config start here --

PROMPT_COMMAND='PROMPT_TIME=$(date "+%a-%d-%b-%Y|%I:%M:%S%p")'
PS1="\[\e[1;33m\]\u\[\e[1;31m\]@\[\e[1;34m\]\h\[\e[1;31m\]@\[\e[1;33m\][\$PROMPT_TIME]\[\e[1;31m\]:\[\e[1;34m\]\w/\[\e[0m\]\n\[\e[1;31m\]\$\[\e[0m\] "

alias upgrayedd='sudo apt update && sudo apt upgrade -y && sudo apt autoremove --purge'
purgex() {
    if [ -z "$1" ]; then
        echo "Format: purgex [-s|--simulate] <package1> [package2 ...]  or  purgex <package1> [package2 ...]"
        return 1
    fi

    case "$1" in
        -s|--simulate)
            if [ -z "$2" ]; then
                echo "Error: Invalid arguments!"
                echo "Format: purgex [-s|--simulate] <package1> [package2 ...]"
                return 1
            fi
            shift
            apt purge --simulate "$@" && apt autoremove --purge --simulate
            for pkg in "$@"; do
                echo "[ $pkg ]"
                apt-cache rdepends --installed "$pkg"
            done
            ;;
        *)
            sudo apt purge -y "$@" && sudo apt autoremove --purge
            ;;
    esac
}
alias xlrun='$HOME/willyhorizont.github.io/cross-language-programming-concepts/xlrun.sh'
alias musicsv='export PYTHONDONTWRITEBYTECODE=1; $HOME/willyhorizont.github.io/musicsv-player/runner.sh $HOME/willyhorizont.github.io/musicsv-player/musicsv-player.sh'

export ALACRITTY_SOCKET_DIR="/tmp"
export WAYLAND_DISPLAY=""
export FZF_DEFAULT_OPTS_FILE=~/.fzfrc

source /usr/share/doc/fzf/examples/key-bindings.bash
source /usr/share/doc/fzf/examples/completion.bash

# source ~/.bashrc

# -- willyhorizont.github.io config end here --
