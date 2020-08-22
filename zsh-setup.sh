# For zsh specific setups

autoload -U colors && colors	# Load colors

# Make the command left and right work with iTerm2
# https://coderwall.com/p/a8uxma/zsh-iterm2-osx-shortcuts
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
