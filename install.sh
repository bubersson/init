#!/bin/bash
# Installation script for the bindings.

# Set defaults
if [ -t 1 ] && [ -n "$TERM" ] && [ "$TERM" != "dumb" ]; then
    RED=$(tput setaf 1) #'\033[31m'
    GREEN=$(tput setaf 2) #'\033[32m'
    YELLOW=$(tput setaf 3) #'\033[33m'
    BLUE=$(tput setaf 4) #'\033[34m'
    GRAY=$(tput setaf 8) #'\033[90m'
    DGRAY=$(tput setaf 236)
    WHITE=$(tput bold)$(tput setaf 15)
    RESET=$(tput sgr0) #'\033[0m'
fi

INFO="${BLUE}[i]${RESET}"
TICK="${GREEN}[✓]${RESET}"
CROSS="${RED}[✗]${RESET}"
EMPTY="${DGRAY}[ ]${RESET}"

HOME_PATH=$HOME
INSTALL_PATH="${HOME_PATH}/init"
INSTALL_REPO="https://github.com/bubersson/init.git"

_help() { cat <<xoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxo
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
    ${GREEN}ghostty   ${RESET}Installs ghostty terminal config.

xoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxo
}

_backup() {
    local target="$1"
    [[ "$target" != /* ]] && target="${HOME_PATH}/$target"
    if [ -e "$target" ] || [ -L "$target" ]; then
        mv "$target" "${target}.old"
        echo -e "$INFO Backed up $target as ${target}.old"
    fi
}

_zshrc() {
    local my_machine_name
    if [ -n "$ZSH_VERSION" ]; then
        vared -p "Enter machine name [box]: " -c my_machine_name
    else
        read -r -p "Enter machine name [box]: " my_machine_name
    fi

    my_machine_name=${my_machine_name//$'\r'/}
    my_machine_name=${my_machine_name//$'\n'/}
    my_machine_name=${my_machine_name:-box}
    local escaped_machine_name
    local escaped_install_path
    escaped_machine_name=$(printf '%s' "$my_machine_name" | sed "s/'/'\\\\''/g")
    escaped_install_path=$(printf '%s' "$INSTALL_PATH" | sed "s/'/'\\\\''/g")

    _backup "${HOME_PATH}/.zshrc"
    {
        printf '\n### Init all aliases, bindings, etc. ###\n'
        printf '# Available colors: https://i.imgur.com/okBgrw4.png\n'
        printf "export MY_MACHINE_NAME='%s'\n" "$escaped_machine_name"
        printf 'export MY_PROMPT_CONTEXT_HOST=247\n'
        printf 'export MY_PROMPT_CONTEXT_BG=238\n'
        printf "source '%s/init.sh'\n" "$escaped_install_path"
    } >> "${HOME_PATH}/.zshrc"
    echo -e "$TICK .zshrc installed"
}


_link_dotfile() {
    _backup "$2"
    local error_message
    local base_name=$(basename "$2")
    local dir_name=$(dirname "$2")
    if error_message=$(ln -s "$1" "$2" 2>&1); then
        echo -e " ${DGRAY}├ ${GREEN}✓ ${GRAY}link ${dir_name}/${RESET}${base_name}"
        return 0
    else
        echo -e " ${DGRAY}├ ${RED}✗ ${GRAY}link ${RESET}${base_name}: ${RED}${error_message}${RESET}"
        return 1
    fi
}

_copy_dotfile() {
    _backup "$2"
    local error_message
    local base_name=$(basename "$2")
    local dir_name=$(dirname "$2")
    if error_message=$(cp "$1" "$2" 2>&1); then
        echo -e " ${DGRAY}├ ${GREEN}✓ ${GRAY}copy ${dir_name}/${RESET}${base_name}"
        return 0
    else
        echo -e " ${DGRAY}├ ${RED}✗ ${GRAY}copy ${RESET}${base_name}: ${RED}${error_message}${RESET}"
        return 1
    fi
}

_dotfiles() {
    _nano_config    ; echo ""
    _mc_config      ; echo ""
    _micro_config   ; echo ""
    _kitty_config   ; echo ""
    _ghostty_config ; echo ""
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
    _copy_dotfile "${INSTALL_PATH}/configs/mc/hop-dark-skin.ini" "${HOME_PATH}/.local/share/mc/skins/hop-dark-skin.ini" || has_error=true
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

_ghostty_config () {
    local has_error=false
    echo -e "${EMPTY} configuring ghostty"
    mkdir -p ~/.config/ghostty
    _link_dotfile "${INSTALL_PATH}/configs/ghostty/config" "${HOME_PATH}/.config/ghostty/config" || has_error=true
    _copy_dotfile "${INSTALL_PATH}/configs/ghostty/config-linux" "${HOME_PATH}/.config/ghostty/config-linux" || has_error=true
    if $has_error ; then
        echo -e "$CROSS ghostty config returned error"
    else
        echo -e "$TICK ghostty configured"
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
    echo -e "$INFO Starting installation of hopkeyboard using keyd"

    if ! command -v keyd &> /dev/null; then
        echo -e "$CROSS keyd is not available. Attempting to install from apt."
        sudo apt install keyd
        if [ -x /usr/bin/keyd.rvaiya ] && [ ! -e /usr/bin/keyd ]; then
            echo -e "$INFO Creating a link ln -s /usr/bin/keyd.rvaiya /usr/bin/keyd"
            sudo ln -s /usr/bin/keyd.rvaiya /usr/bin/keyd
        fi
        if ! command -v keyd &> /dev/null; then
            echo -e "$CROSS keyd is not available. Attempting to install from source."
            echo -e "$INFO Downloading build pre-requisities"
            sudo apt install build-essential autoconf automake
            mkdir -p ~/apps && cd ~/apps || return 1
            if [ ! -d ~/apps/keyd ]; then
                echo -e "$INFO Clonning keyd from git"
                git clone https://github.com/rvaiya/keyd || return 1
            fi
            cd ~/apps/keyd || return 1
            echo -e "$INFO Installing keyd"
            make && sudo make install || return 1
        fi
    fi

    echo -e "$INFO Enabling keyd service"
    sudo mkdir -p /etc/keyd
    sudo cp "${INSTALL_PATH}/keyboard/xkb-custom-keyboard/keyd.default.conf" "/etc/keyd/default.conf" || return 1
    sudo systemctl enable --now keyd
    sudo systemctl restart keyd
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
        sudo apt install -y git zsh
    fi

    # Clone repo
    git clone "$INSTALL_REPO" "$INSTALL_PATH"
    echo -e "$TICK Repository clonned"

    echo -e "$INFO Change default shell to zsh, install .zshrc and other dotfiles"
    local zsh_path
    zsh_path=$(command -v zsh)
    sudo chsh -s "$zsh_path" "${USER:-$(id -un)}"
    echo -e "$TICK Shell changed to $zsh_path"

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
    --help|-h)  _help           ; exit 0 ;;
    install)    _install        ; exit 0 ;;
    up)         _up             ; exit 0 ;;
    dotfiles)   _dotfiles       ; exit 0 ;;
    zshrc)      _zshrc          ; exit 0 ;;
    apps)       _apps           ; exit 0 ;;
    keyboard)   _keyboard       ; exit 0 ;;
    mc)         _mc_config      ; exit 0 ;;
    micro)      _micro_config   ; exit 0 ;;
    kitty)      _kitty_config   ; exit 0 ;;
    ghostty)    _ghostty_config ; exit 0 ;;
    git)        _git_config     ; exit 0 ;;
    *)          _help           ; exit 0 ;;
    esac
fi
