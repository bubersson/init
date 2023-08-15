#!/bin/bash

RED=$(tput setaf 1) #'\033[31m'
GREEN=$(tput setaf 2) #'\033[32m'
YELLOW=$(tput setaf 3) #'\033[33m'
BLUE=$(tput setaf 4) #'\033[34m'
GRAY=$(tput setaf 8) #'\033[90m'
RESET=$(tput sgr0) #'\033[0m'
LIGHT_BLUE=$(tput setaf 14) #'\033[34m'

INFO="${BLUE}[i]${RESET}"
TICK="${GREEN}[✓]${RESET}"
CROSS="${RED}[✗]${RESET}"