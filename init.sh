# Initializes shell bindings on shell startup. 

source ~/init/scripts/defaults.sh

echo -e "$INFO Running init/init.sh"

source ~/init/paths.sh
source ~/init/git-commands.sh

[[ $0 == "bash" ]] && source ~/init/bash-setup.sh || source ~/init/zsh-setup.sh

source ~/init/aliases.sh

echo -e "$TICK Finished setting up all init bindings\n"
