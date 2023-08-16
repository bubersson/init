#!/bin/bash
# Installation script for the bindings.

# Set defaults
RED=$(tput setaf 1) #'\033[31m'
GREEN=$(tput setaf 2) #'\033[32m'
YELLOW=$(tput setaf 3) #'\033[33m'
BLUE=$(tput setaf 4) #'\033[34m'
GRAY=$(tput setaf 8) #'\033[90m'
RESET=$(tput sgr0) #'\033[0m'

INFO="${BLUE}[i]${RESET}"
TICK="${GREEN}[✓]${RESET}"
CROSS="${RED}[✗]${RESET}"

HOME_PATH=~
INSTALL_PATH="${HOME_PATH}/init"

_help() {
    cat <<DOCUMENTATION
${GREEN}install.sh${RESET}
Installation of all init bindings. 

${YELLOW}USAGE:${RESET}
    ./install.sh <SUBCOMMAND>
    
${YELLOW}SUBCOMMANDS:${RESET}
    ${GREEN}dotfiles  ${RESET}Links dotfiles from home folder to the clonned git folder. 
    ${GREEN}zshrc     ${RESET}Creates *new* .zshrc file. 

DOCUMENTATION

}

_zshrc() {    
    local my_machine_name
    if [ -n "$ZSH_VERSION" ]; then
        vared -p "Enter machine name [box]: " -c my_machine_name
    else
        read -p "Enter machine name [box]: " my_machine_name
    fi
    
    my_machine_name=${my_machine_name:-box}
    if [ -f "${HOME_PATH}/.zshrc" ]; then
        mv "${HOME_PATH}"/.zshrc{,.old}
        echo -e "$INFO Backed up .zshrc as .zshrc.old"
    fi
    touch "${HOME_PATH}/.zshrc"
    echo -e "\n### Init all aliases, bindings, etc. ###" >> "${HOME_PATH}/.zshrc"
    echo -e "# Available colors: https://i.imgur.com/okBgrw4.png" >> "${HOME_PATH}/.zshrc"
    echo -e "export MY_MACHINE_NAME=${my_machine_name}" >> "${HOME_PATH}/.zshrc"
    echo -e "export MY_PROMPT_CONTEXT_HOST=247" >> "${HOME_PATH}/.zshrc"
    echo -e "export MY_PROMPT_CONTEXT_BG=238" >> "${HOME_PATH}/.zshrc"
    echo -e "source ${INSTALL_PATH}/init.sh" >> "${HOME_PATH}/.zshrc"
    echo -e "$TICK .zshrc installed"
}


_link_dotfile() {
    if [ -f "${HOME_PATH}/$1" ]; then
        mv "${HOME_PATH}/$1"{,.old}
        echo -e "$INFO Backed up $1 as $1.old"
    fi
    ln -s "${INSTALL_PATH}/dotfiles/$1" "${HOME_PATH}/$1"
    echo -e "$TICK $1 installed"
}

_dotfiles() {
    _link_dotfile ".nanorc"
}

_install() {
    # Check existing scripts
    if [ ! -z "$MY_MACHINE_NAME" ]; then
        echo -e "$CROSS Already installed. Redirecting from install.sh to init.sh."
        echo -e "$INFO Please run ${GRAY}~/init/install.sh zshrc ${RESET}to source '~/init/init.sh'\n"
        source ~/init/init.sh
        return
    fi

    cd $HOME_PATH

    # Install dependencies
    echo -e "${GREEN}Running install.sh${RESET}"
    echo -e "$INFO Starting install process"
    echo -e "$INFO Install pre-requisities: zsh and git"
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install git zsh
    fi
    if [[ "$(uname)" == "Linux" ]]; then
        sudo apt install git zsh
    fi

    # Clone repo
    git clone https://github.com/bubersson/init.git $INSTALL_PATH
    echo -e "$TICK Repository clonned"

    echo -e "$INFO Change default shell to zsh, install .zshrc and other dotfiles"
    sudo chsh -s $(which zsh)
    echo -e "$TICK Shell changed to $(which zsh)"

    # Setup dotfiles
    _zshrc 
    _dotfiles

    echo -e "$TICK All$GREEN DONE$RESET. Running zsh now...\n"

    zsh
}

case $1 in
  --help|-h)  _help       ; exit 0 ;;
  dotfiles)   _dotfiles   ; exit 0 ;;  
  zshrc)      _zshrc      ; exit 0 ;;  
  *)          _install    ; return ;;
esac