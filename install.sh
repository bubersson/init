# Installs and configures shell.
# First switch to zsh:
# chsh -s /bin/zsh

GREEN=$(tput setaf 2) #'\033[32m'
BLUE=$(tput setaf 4) #'\033[34m'
RESET=$(tput sgr0) #'\033[0m'

echo -e "[${BLUE}START${RESET}] Running init/install.sh"

source ~/init/paths.sh
source ~/init/git-commands.sh

[[ $0 == "bash" ]] && source ~/init/bash-setup.sh || source ~/init/zsh-setup.sh

source ~/init/aliases.sh

echo -e "[${GREEN}DONE${RESET}] Finished setting up all init bindings\n"
