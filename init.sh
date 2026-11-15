# Initializes shell bindings on shell startup.

# Fall back to xterm-256color when remote/local terminfo lacks $TERM (e.g. xterm-ghostty or xterm-kitty over SSH)
if [ -n "$TERM" ] && [ "$TERM" != "dumb" ]; then
    if command -v infocmp >/dev/null 2>&1; then
        infocmp "$TERM" >/dev/null 2>&1 || export TERM="xterm-256color"
    elif command -v tput >/dev/null 2>&1; then
        tput longname >/dev/null 2>&1 || export TERM="xterm-256color"
    fi
fi

source ~/init/scripts/defaults.sh

echo -e "$INFO Running init/init.sh"

source ~/init/paths.sh
source ~/init/git-commands.sh

if [ -n "$ZSH_VERSION" ]; then
    source ~/init/zsh-setup.sh
else
    source ~/init/bash-setup.sh
fi

source ~/init/aliases.sh

echo -e "$TICK Finished setting up all init bindings\n"
