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

HOME_PATH=$HOME
INSTALL_PATH="${HOME_PATH}/init"
INSTALL_REPO="https://github.com/bubersson/init.git"

_help() {
    cat <<DOCUMENTATION
${GREEN}install.sh${RESET}
Installation of all init bindings.

${YELLOW}USAGE:${RESET}
    ./install.sh
    ./install.sh <SUBCOMMAND>

${YELLOW}SUBCOMMANDS:${RESET}
    ${GREEN}dotfiles  ${RESET}Links dotfiles from home folder to the clonned git folder.
    ${GREEN}zshrc     ${RESET}Creates *new* .zshrc file.
    ${GREEN}apps      ${RESET}Install common useful apps
    ${GREEN}keyboard  ${RESET}Installs hop keyboard layout on Linux.
    ${GREEN}mc        ${RESET}Installs custom mc config and styles.
    ${GREEN}micro     ${RESET}Installs custom micro config and styles.

DOCUMENTATION

}

_backup() {
    if [ -f "${HOME_PATH}/$1" ]; then
        mv "${HOME_PATH}/$1"{,.old}
        echo -e "$INFO Backed up $1 as $1.old"
    fi
}

_zshrc() {
    local my_machine_name
    if [ -n "$ZSH_VERSION" ]; then
        vared -p "Enter machine name [box]: " -c my_machine_name
    else
        read -p "Enter machine name [box]: " my_machine_name
    fi

    my_machine_name=${my_machine_name:-box}

    _backup ".zshrc"
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
    _backup $1
    ln -s "${INSTALL_PATH}/dotfiles/$1" "${HOME_PATH}/$1"
    echo -e "$TICK $1 installed"
}

_dotfiles() {
    _link_dotfile ".nanorc"
}

_mc_config() {
    # config
    mkdir -p ~/.config/mc
    cp ~/init/configs/mc/ini ~/.config/mc/ini
    cp ~/init/configs/mc/filehighlight.ini ~/.config/mc/filehighlight.ini
    cp ~/init/configs/mc/mc.keymap ~/.config/mc/mc.keymap
    # skin
    mkdir -p ~/.local/share/mc/skins
    cp ~/init/configs/mc/hop-dark-skin.ini ~/.local/share/mc/skins/hop-dark-skin.ini
    echo -e "$TICK Midnight Commander configured"
}

_micro_config() {
    # config
    mkdir -p ~/.config/micro
    cp ~/init/configs/micro/bindings.json ~/.config/micro/bindings.json
    cp ~/init/configs/micro/settings.json ~/.config/micro/settings.json
    # skin
    mkdir -p ~/.config/micro/colorschemes
    cp ~/init/configs/micro/colorschemes/hop-dark.micro ~/.config/micro/colorschemes/hop-dark.micro
    echo -e "$TICK Micro editor configured"
}

_keyboard() {
    # Notes:
    # - the sed only applies the replacement on the first occurence
    # - may need to restart the machine after doing this
    # - the `XKBLAYOUT=hopkeyboard` seems to be the main thing that actually switches it
    echo -e "$INFO Starting installation of hopkeyboard"
    sudo cp ~/init/keyboard/xkb-custom-keyboard/hopkeyboard /usr/share/X11/xkb/symbols/hopkeyboard
    echo -e "$TICK Keyboard layout copied under /usr/share/X11/xkb/symbols/hopkeyboard"

    sudo sed -i.bak "0,/<variantList>/{s|<variantList>|\
    <variantList>\n\
            <variant>\n\
                <configItem>\n\
                    <name>hopkeyboard</name>\n\
                    <description>English (US, Hop - Mac friendly touches)</description>\n\
                </configItem>\n\
            </variant>\n\
    |}" /usr/share/X11/xkb/rules/evdev.xml
    echo -e "$TICK Variant added to /usr/share/X11/xkb/rules/evdev.xml"

    sudo bash -c 'cat > /etc/default/keyboard << ENDOFFILE
XKBLAYOUT=hopkeyboard
BACKSPACE=guess
ENDOFFILE'
    echo -e "$TICK Keyboard added to /etc/default/keyboard"

    cat >> .profile << ENDOFFILE
### Fix the repeated keys with hopkeyboard
xset r on
xset r 22
seq 111 116 | xargs -n 1 xset r
ENDOFFILE
    echo -e "$TICK Updated .profile to fix key repeating issues"

    echo -e "$INFO Please restart the computer now to see applied changes"
    echo -e "$INFO You may need to select the Hop Keyboard from the language selection"
}

_apps() {
	if [[ "$(uname)" == "Darwin" ]]; then
        brew install mc micro htop curl
    fi
    if [[ "$(uname)" == "Linux" ]]; then
        sudo apt install mc micro htop curl
    fi
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
    git clone $INSTALL_REPO $INSTALL_PATH
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

# When executed without argument, run the actual install.
if [[ $# -eq 0 ]] ; then
    _install;
    return
fi

case $1 in
  --help|-h)  _help          ; exit 0 ;;
  dotfiles)   _dotfiles      ; exit 0 ;;
  zshrc)      _zshrc         ; exit 0 ;;
  apps)       _apps          ; exit 0 ;;
  keyboard)   _keyboard      ; exit 0 ;;
  mc)         _mc_config     ; exit 0 ;;
  micro)      _micro_config  ; exit 0 ;;
  *)          _help          ; exit 0 ;;
esac
