#####################
#### My Aliases #####
#####################

# some more ls aliases
alias ..="cd .."
alias ...="cd .. ; cd .."
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
 
# find process
alias pg='ps -ef | grep '
 
# git svn aliases
alias cdb='git checkout'
alias mkb='git checkout -b'
alias rmb='git branch -D'
alias mergebranch='git merge --squash'
alias diffbranch="git diff --color master...`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`"
alias listbranch="git branch -av"
alias gb="git branch -av"
alias fff=gitfff # fff stands for diFFFiles
alias tree=gittree
alias log=gitlog
alias status="git status -sb"

alias cm="git commit -a -m "

alias server="python -m SimpleHTTPServer"