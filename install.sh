# Installs and configures shell.
# First switch to zsh:
# chsh -s /bin/zsh

echo -e "[\033[34mSTART\033[0m] Running init/install.sh"

source ~/init/paths.sh
source ~/init/git-commands.sh

[[ $0 == "bash" ]] && source ~/init/bash-setup.sh || source ~/init/zsh-setup.sh

source ~/init/aliases.sh

echo -e "[\033[32mDONE\033[0m] Finished setting up all init bindings\n"
