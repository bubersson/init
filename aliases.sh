#####################
#### My Aliases #####
#####################

# Standard one letter aliases
# f - find file
# e - editor
# i - install / update software
# l - list directory
# o - open file in window manager
# s - ssh
# z - jump to folder (fuzzy)

source ~/init/scripts/defaults.sh

# helper
alias dot=~/init/install.sh

# colorize
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'

# handling files and folders
alias ..="cd .."
alias ...="cd .. ; cd .."
alias mc='mc --nosubshell' # for fast start on Mac

if [[ "$(uname)" == "Linux" ]]; then
  alias ll='ls -alhF --group-directories-first'
  alias la='ls -A --group-directories-first'
  alias l='ls -CF --group-directories-first'
else
  alias ll='ls -alhF'
  alias la='ls -A'
  alias l='ls -CF'
fi

export GREP_COLORS="sl=0;38;5;242:ms=0;38;49"
if [[ "$(uname)" == "Darwin" ]]; then
	export GREP_COLOR="0;0;33" # Old, but works on MacOS default grep.
fi

# Find file by prefix (ignore case). Usage: `f` or `f myfile` or `f myfile.txt \etc` or `f '*css'`
function f() {
  find ${2:-.} -iname "${1}*" 2>/dev/null | grep '^\|[^/]*$'
}
# We use noglob, so zsh doesn't expand characters like "*" and so we can do e.g. `f *css`
alias f='noglob f'

# Find files that contain the given string (case insensitive), print file, line and preview.
function ff() {
  grep -RInwis ${2:-.} -e "${1}"
}


function mkd() { mkdir -p ${1} ; cd ${1} } # make dir and cd into it

 # Install z
. ~/init/scripts/z.sh

# find process
alias pg='ps -ef | grep '

# git aliases
alias cdb='git switch'
alias mkb='git switch -c'
alias rmb='git branch -D'
alias cm=gitcm
alias cme=gitcme # commit and export
alias gb="git branch -av"
alias status="git status -sb"
alias fff=gitfff # fff stands for diFFFiles
alias tree=gittree
alias log=gitlog
alias diffbranch="git diff --color master...`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`"
alias mergebranch='git merge --squash'

# networking
alias s=identity-tool

if [[ "$(uname)" == "Darwin" ]]; then
  alias ports="sudo lsof -PiTCP -sTCP:LISTEN"
  alias router="netstat -rn |grep default"
  alias ip-private="ipconfig getifaddr en0"
  alias ip-public="curl -4 ifconfig.co"
  alias battery="system_profiler SPPowerDataType"
fi
if [[ "$(uname)" == "Linux" ]]; then
  alias ports="netstat -tulnp | grep LISTEN"
  alias router="ip route"
  alias ip-private="hostname -I | awk {'print $1}'"
  alias ip-public="curl -4 ifconfig.co"
  alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
fi
function server() {
  if command -v python3 &> /dev/null; then
    python3 -m http.server ${1}
  elif command -v python &> /dev/null; then
    python -m SimpleHTTPServer ${1}
  else
    echo -e "${CROSS} ${RED}ERROR:${RESET} python or python3 not found"
  fi
}

export MANPAGER='less -s -M +Gg'
function man() {
    env \
    LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
    LESS_TERMCAP_md="$(printf "\e[1;33m")" \
    LESS_TERMCAP_so="$(printf "\e[01;44;37m")" \
    LESS_TERMCAP_us="$(printf "\e[1;37m")" \
    LESS_TERMCAP_me="$(printf "\e[0m")" \
    LESS_TERMCAP_se="$(printf "\e[0m")" \
    LESS_TERMCAP_ue="$(printf "\e[0m")" \
    GROFF_NO_SGR=1 \
    man "${@}"
}

# editor
if command -v micro &> /dev/null; then
  # If micro is available, use micro.
  export EDITOR=$(which micro)
  alias e=$(which micro)
else
  export EDITOR=$(which nano)
  alias e=$(which nano)
fi

# system
alias path='echo $PATH | tr -s ":" "\n"'

# Mac OS X only.
function _run_updates_mac() {
  if command -v brew &> /dev/null; then
    echo -e "$INFO Running$WHITE brew-refresh ; brew update ; brew upgrade$RESET"
    brew-refresh
    brew update
    brew upgrade
  else
    echo -e "$CROSS brew not found"
  fi
}
if [[ "$(uname)" == "Darwin" ]]; then
  alias i='brew'
  alias o='open -a Finder' # Open folder or file in the default application (e.g. Finder)
  alias up=_run_updates_mac
fi

# Linux only.
function _run_updates_linux() {
  if command -v nala &> /dev/null; then
    echo -e "$INFO Running$WHITE sudo nala update ; sudo nala upgrade -y$RESET"
    sudo nala update
    sudo nala upgrade -y
  elif command -v apt &> /dev/null; then
    echo -e "$INFO Running$WHITE sudo apt update ; sudo apt upgrade -y$RESET"
    sudo apt update
    sudo apt upgrade -y
  fi
  if command -v flatpak &> /dev/null; then
    echo -e "$INFO Running$WHITE flatpak update -y$RESET"
    flatpak update -y
  fi
}
if [[ "$(uname)" == "Linux" ]]; then
  if command -v nala &> /dev/null; then
    alias i='sudo nala'
  else
    alias i='sudo apt'
  fi
  alias o='xdg-open'
  alias up=_run_updates_linux
fi

# If ccat exists, alias it to cat.
if command -v ccat &> /dev/null; then
  alias cat='ccat --bg="dark" $*'
fi

if [[ "$(uname)" == "Linux" ]]; then
  if command -v spd-say &> /dev/null; then
    alias say='spd-say'
  fi
fi
