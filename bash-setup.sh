# needs to be executed after git-commands.sh

#export PS1="\[\033[33m\]\u\[\033[35m\]@\h:\[\e[32m\]\$(parse_git_branch) \[\033[36m\]\w\033[0m\n$ "
export PS1="\[\033[33m\]\u\[\033[35m\]@pro2:\[\e[32m\]\$(parse_git_branch) \[\033[36m\]\w\033[0m\n$ "

# LS colors
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
 
# Much better search in history with using just up/down arrow after the word 
# prefix. E.g. write "cop", press up arrow and see "copy a.txt b.txt".
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
