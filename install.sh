#!/bin/bash
# Installation script for the bindings.

# Set defaults
RED=$(tput setaf 1) #'\033[31m'
GREEN=$(tput setaf 2) #'\033[32m'
YELLOW=$(tput setaf 3) #'\033[33m'
BLUE=$(tput setaf 4) #'\033[34m'
GRAY=$(tput setaf 8) #'\033[90m'
DGRAY=$(tput setaf 236)
WHITE=$(tput bold)$(tput setaf 15)
RESET=$(tput sgr0) #'\033[0m'

INFO="${BLUE}[i]${RESET}"
TICK="${GREEN}[✓]${RESET}"
CROSS="${RED}[✗]${RESET}"
EMPTY="${DGRAY}[ ]${RESET}"

HOME_PATH=$HOME
INSTALL_PATH="${HOME_PATH}/init"
INSTALL_REPO="https://github.com/bubersson/init.git"

_help() {
    cat <<DOCUMENTATION
${GREEN}install.sh${RESET} (alias ${GREEN}dot${RESET})
Installation of all init bindings.

${YELLOW}USAGE:${RESET}
    ./install.sh
    ./install.sh <SUBCOMMAND>

${YELLOW}SUBCOMMANDS:${RESET}
    ${GREEN}install   ${RESET}Runs the new installation (no checks for existing).
    ${GREEN}up        ${RESET}Update the init bindings (pull from github).
    ${GREEN}dotfiles  ${RESET}Links dotfiles from home folder to the clonned git folder.
    ${GREEN}zshrc     ${RESET}Creates *new* .zshrc file.
    ${GREEN}apps      ${RESET}Install common useful apps
    ${GREEN}keyboard  ${RESET}Installs hop keyboard layout on Linux.
    ${GREEN}mc        ${RESET}Installs custom mc config and styles.
    ${GREEN}micro     ${RESET}Installs custom micro config and styles.
    ${GREEN}kitty     ${RESET}Installs kitty terminal config.
    ${GREEN}git       ${RESET}Installs global git .gitconfig and .gitignore.

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
    _backup $2
    local error_message=$( ln -s "$1" "$2" 2>&1)
    local base_name=$(basename $2)
    local dir_name=$(dirname $2)
    if [[ -z "${error_message// }" ]]; then
        echo -e " ${DGRAY}├ ${GREEN}✓ ${GRAY}link ${dir_name}/${RESET}${base_name}"
        return 0
    else
        echo -e " ${DGRAY}├ ${RED}✗ ${GRAY}link ${RESET}${base_name}: ${RED}${error_message}${RESET}"
        return 1
    fi
}

_copy_dotfile() {
    _backup $2
    local error_message=$( cp "$1" "$2" 2>&1)
    local base_name=$(basename $2)
    local dir_name=$(dirname $2)
    if [[ -z "${error_message// }" ]]; then
        echo -e " ${DGRAY}├ ${GREEN}✓ ${GRAY}copy ${dir_name}/${RESET}${base_name}"
        return 0
    else
        echo -e " ${DGRAY}├ ${RED}✗ ${GRAY}copy ${RESET}${base_name}: ${RED}${error_message}${RESET}"
        return 1
    fi
}

_dotfiles() {
    _nano_config
    echo ""
    _mc_config
    echo ""
    _micro_config
    echo ""
    _kitty_config
    echo ""
    _git_config
}

_nano_config() {
    local has_error=false
    echo -e "${EMPTY} configuring nano"
    _link_dotfile "${INSTALL_PATH}/dotfiles/.nanorc" "${HOME_PATH}/.nanorc" || has_error=true
    if $has_error ; then
        echo -e "$CROSS nano config returned error"
    else
        echo -e "$TICK nano configured"
    fi
}

_mc_config() {
    local has_error=false
    echo -e "${EMPTY} configuring mc"
    # config
    mkdir -p ~/.config/mc
    _copy_dotfile "${INSTALL_PATH}/configs/mc/ini" "${HOME_PATH}/.config/mc/ini" || has_error=true
    _copy_dotfile "${INSTALL_PATH}/configs/mc/filehighlight.ini" "${HOME_PATH}/.config/mc/filehighlight.ini" || has_error=true
    _copy_dotfile "${INSTALL_PATH}/configs/mc/mc.keymap" "${HOME_PATH}/.config/mc/mc.keymap" || has_error=true
    # skin
    mkdir -p ~/.local/share/mc/skins
    _copy_dotfile "${INSTALL_PATH}/configs/mc/hop-dark-skin.ini" "${HOME_PATH}/.local/share/mc/skins/hop-dark-skin.ini"
    if $has_error ; then
        echo -e "$CROSS mc config returned error"
    else
        echo -e "$TICK mc configured"
    fi
}

_micro_config() {
    local has_error=false
    echo -e "${EMPTY} configuring micro"
    # config
    mkdir -p ~/.config/micro
    _link_dotfile "${INSTALL_PATH}/configs/micro/bindings.json" "${HOME_PATH}/.config/micro/bindings.json" || has_error=true
    _link_dotfile "${INSTALL_PATH}/configs/micro/settings.json" "${HOME_PATH}/.config/micro/settings.json" || has_error=true
    # skin
    mkdir -p ~/.config/micro/colorschemes
    _link_dotfile "${INSTALL_PATH}/configs/micro/colorschemes/hop-dark.micro" "${HOME_PATH}/.config/micro/colorschemes/hop-dark.micro" || has_error=true
    if $has_error ; then
        echo -e "$CROSS micro config returned error"
    else
        echo -e "$TICK micro configured"
    fi
}

_kitty_config () {
    local has_error=false
    echo -e "${EMPTY} configuring kitty"
    mkdir -p ~/.config/kitty
    _link_dotfile "${INSTALL_PATH}/configs/kitty/kitty.conf" "${HOME_PATH}/.config/kitty/kitty.conf" || has_error=true
    _link_dotfile "${INSTALL_PATH}/configs/kitty/tab_bar.py" "${HOME_PATH}/.config/kitty/tab_bar.py" || has_error=true
    if $has_error ; then
        echo -e "$CROSS kitty config returned error"
    else
        echo -e "$TICK kitty configured"
    fi
}

_git_config() {
    local has_error=false
    echo -e "${EMPTY} configuring git"
    _copy_dotfile "${INSTALL_PATH}/dotfiles/.gitconfig" "${HOME_PATH}/.gitconfig" || has_error=true
    _copy_dotfile "${INSTALL_PATH}/dotfiles/.gitignore" "${HOME_PATH}/.gitignore" || has_error=true
    if $has_error ; then
        echo -e "$CROSS git config returned error"
    else
        echo -e "$TICK git configured"
    fi
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

    cat >> ~/.profile << ENDOFFILE
### Fix the repeated keys with hopkeyboard
xset r on
xset r 22
seq 111 116 | xargs -n 1 xset r
ENDOFFILE
    echo -e "$TICK Updated .profile to fix key repeating issues"

    # Need to run following scripts to force GNOME to use XKB (otherwise it uses its own thing)
    echo -e "$INFO Checking current GNOME keyboard settings"
    gsettings get org.gnome.desktop.input-sources sources
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+hopkeyboard'), ('xkb', 'us')]"
    echo -e "$TICK Changed current GNOME keyboard settings to [('xkb', 'us+hopkeyboard'), ('xkb', 'us')]"

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

    echo -e "$TICK All$GREEN DONE$RESET.\n"
    echo -e "${YELLOW}NEXT STEPS:${RESET}"
    echo -e "   run ${WHITE}zsh${RESET} now..."
    echo -e "   run ${WHITE}dot apps${RESET} to install apps...\n"
}

_up() {
    echo -e "$INFO Updating the init installation"
    pushd ~/init > /dev/null
    git pull
    popd > /dev/null
    zsh
}

# When executed without argument, run the actual install.
if [[ $# -eq 0 ]] ; then
    # Check existing scripts
    if [ ! -z "$MY_MACHINE_NAME" ]; then
        if [ -n "$ZSH_VERSION" ]; then
            # We are already installed and sourced from old ~/.zshrc
            echo -e "$CROSS Already installed. Redirecting from install.sh to init.sh."
            echo -e "$INFO Please run ${GRAY}~/init/install.sh zshrc ${RESET}to source '~/init/init.sh'\n"
            source ~/init/init.sh
        else
            # We are already installed and executed as a script or alias.
            _help
        fi
    else
        # We are not installed: either first time direct execution or via curl | bash.
        _install
    fi
else
    case $1 in
    --help|-h)  _help          ; exit 0 ;;
    install)    _install       ; exit 0 ;;
    up)         _up            ; exit 0 ;;
    dotfiles)   _dotfiles      ; exit 0 ;;
    zshrc)      _zshrc         ; exit 0 ;;
    apps)       _apps          ; exit 0 ;;
    keyboard)   _keyboard      ; exit 0 ;;
    mc)         _mc_config     ; exit 0 ;;
    micro)      _micro_config  ; exit 0 ;;
    kitty)      _kitty_config  ; exit 0 ;;
    git)        _git_config    ; exit 0 ;;
    *)          _help          ; exit 0 ;;
    esac
fi