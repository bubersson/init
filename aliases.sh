#####################
#### My Aliases #####
#####################

# some more ls aliases
alias ..="cd .."
alias ...="cd .. ; cd .."

alias ls='ls --color=auto'
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

# find process 
alias pg='ps -ef | grep '

# git svn aliases
alias cdb='git switch'
alias mkb='git switch -c'
alias rmb='git branch -D'
alias cm="git commit -a -m "
alias gcm='git commit -m '
alias mergebranch='git merge --squash'
alias diffbranch="git diff --color master...`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`"
alias gb="git branch -av"
alias fff=gitfff # fff stands for diFFFiles
alias tree=gittree
alias log=gitlog
alias cme=gitcme # commit and export
alias status="git status -sb"
alias please="sudo"

alias server="python -m SimpleHTTPServer"

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
    alias f='open -a Finder'
    alias i='brew'

    # Install z. See https://formulae.brew.sh/formula/z
    . $(brew --prefix)/etc/profile.d/z.sh

    alias up='brew-refresh; brew update; brew upgrade'
fi

# Linux only.
if [[ "$(uname)" == "Linux" ]]; then
    # apt-get & similar
    alias i='sudo apt'    
    alias f='xdg-open'
    alias up='sudo apt update; sudo apt upgrade'
fi

# If ccat exists, alias it to cat.
if command -v ccat &> /dev/null; then
    alias cat='ccat --bg="dark" $*'
fi
