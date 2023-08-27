#####################
#### My Aliases #####
#####################

source ~/init/scripts/defaults.sh

# some more ls aliases
alias ..="cd .."
alias ...="cd .. ; cd .."

alias ls='ls --color=auto'
alias ip='ip --color=auto'
alias grep='grep --color=auto'
alias mc='mc --nosubshell' # for fast start on Mac

# Linux only
if [[ "$(uname)" == "Linux" ]]; then
  alias ll='ls -alhF --group-directories-first'
  alias la='ls -A --group-directories-first'
  alias l='ls -CF --group-directories-first'
else
  alias ll='ls -alhF'
  alias la='ls -A'
  alias l='ls -CF'
fi

# make dir and cd into it
function mkd { mkdir -p ${1} ; cd ${1} }

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
if [[ "$(uname)" == "Darwin" ]]; then
  alias ports="sudo lsof -PiTCP -sTCP:LISTEN"
  alias router="netstat -rn |grep default"
  alias ip-private="ipconfig getifaddr en0"
  alias ip-public="curl -4 ifconfig.co"  
fi
if [[ "$(uname)" == "Linux" ]]; then
  alias ports="netstat -tulnp | grep LISTEN"
  alias router="ip route"
  alias ip-private="hostname -I | awk {'print $1}'"
  alias ip-public="curl -4 ifconfig.co"  
fi

# system
alias path='echo $PATH | tr -s ":" "\n"'

function server() {
  if command -v python3 &> /dev/null; then
    python3 -m http.server ${1}
  elif command -v python &> /dev/null; then
    python -m SimpleHTTPServer ${1}
  else
    echo -e "${RED}ERROR:${RESET} python or python3 not found"
  fi
}

function fd() {
  # Find file by prefix, ignoring case. By default it searches under current directory.
  # Usage: `fd myfile` or `fd myfile.txt ~`
  find ${2:-.} -iname "${1}*" 2>/dev/null
}

# Install z
. ~/init/scripts/z.sh

# Mac OS X only.
if [[ "$(uname)" == "Darwin" ]]; then
    # Open current folder in finder (Mac OS X only)
    alias i='brew'
    alias f='open -a Finder'
    alias up='brew-refresh; brew update; brew upgrade'
fi

function _run_updates() {
  if command -v apt &> /dev/null; then
    echo -e "$INFO Running$WHITE sudo apt update ; sudo apt upgrade$RESET"
    sudo apt update
    sudo apt upgrade
  fi
  if command -v flatpak &> /dev/null; then
    echo -e "$INFO Running$WHITE flatpak update$RESET"
    flatpak update
  fi
}

# Linux only.
if [[ "$(uname)" == "Linux" ]]; then
    alias i='sudo apt'
    alias f='xdg-open'
    alias up=_run_updates
fi

# If ccat exists, alias it to cat.
if command -v ccat &> /dev/null; then
    alias cat='ccat --bg="dark" $*'
fi

# Configure editor. If micro is available, use micro. 
if command -v micro &> /dev/null; then
    export EDITOR=$(which micro)
    alias nano=$(which micro)    
fi
