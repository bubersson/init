#####################
#### My Aliases #####
#####################

# some more ls aliases
alias ..="cd .."
alias ...="cd .. ; cd .."
alias ll='ls -alhF --group-directories-first'
alias la='ls -A --group-directories-first'
alias l='ls -CF --group-directories-first'

# find process
alias pg='ps -ef | grep '

# git svn aliases
alias cdb='git checkout'
alias mkb='git checkout -b'
alias rmb='git branch -D'
alias cm="git commit -a -m "
alias gcm='git commit -m '
alias mergebranch='git merge --squash'
alias diffbranch="git diff --color master...`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`"
alias listbranch="git branch -av"
alias gb="git branch -av"
alias fff=gitfff # fff stands for diFFFiles
alias tree=gittree
alias log=gitlog
alias cme=gitcme # commit and export
alias status="git status -sb"

alias server="python -m SimpleHTTPServer"

# Mac OS X only.
if [[ "$(uname)" == "Darwin" ]]; then
    # Open current folder in finder (Mac OS X only)
    alias f='open -a Finder'
    alias i='brew'
fi

# Linux only
if [[ "$(uname)" == "Linux" ]]; then
    # apt-get & similar
    alias i='sudo apt'    
fi

# If ccat exists, alias it to cat
if command -v ccat &> /dev/null; then
    alias cat="ccat $*"
fi
