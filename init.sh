# Initializes shell bindings on shell startup. 

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
