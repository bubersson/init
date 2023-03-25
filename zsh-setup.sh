# ZSH CONFIGURATION
# For zsh specific setups

autoload -U colors && colors	# Load colors

# Enable ls colors
alias ls='ls -G'
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Much better search in history with using just up/down arrow after the word 
# prefix. E.g. write "cop", press up arrow and see "copy a.txt b.txt".
if [[ "$(uname)" == "Darwin" ]]; then #Mac
    bindkey "^[[A" history-beginning-search-backward
    bindkey "^[[B" history-beginning-search-forward
else # Linux
    bindkey "$key[Up]" history-beginning-search-backward
    bindkey "$key[Down]" history-beginning-search-forward
fi

# Make the command left and right work with iTerm2
# https://coderwall.com/p/a8uxma/zsh-iterm2-osx-shortcuts
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Make delete work to delete a char.
bindkey "^[[3~" delete-char

# History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

# History command configuration
# http://zsh.sourceforge.net/Doc/Release/Options.html#Options
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# Autocompletion load (this could be slow)
# fpath=(/usr/local/share/zsh-completions $fpath)
# autoload -U compinit && compinit
# zmodload -i zsh/complist

# Experience configuration
# https://wiki.archlinux.org/index.php/zsh#Configure_Zsh
# zstyle ':completion:*' menu select
setopt interactive_comments   # allow copypasting scripts with "#" comments

# Install ZSH Prompt
setopt auto_cd
setopt multios
setopt prompt_subst # enables substitution in prompt
autoload -Uz vcs_info # from git command
source ~/init/zsh-theme/hop-zsh-prompt.sh
