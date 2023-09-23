# ZSH CONFIGURATION
# For zsh specific setups

autoload -U colors && colors	# Load colors

# Enable ls colors
export LSCOLORS="Gxfxcxdxbxegedabagacad" # Applies on MacOS(BSD) only.

# Much better search in history with using just up/down arrow after the word
# prefix. E.g. write "cop", press up arrow and see "copy a.txt b.txt".
if [[ "$(uname)" == "Darwin" ]]; then #Mac
    bindkey "^[[A" history-beginning-search-backward
    bindkey "^[[B" history-beginning-search-forward
    # opt out of brew analytics on Mac
    export HOMEBREW_NO_ANALYTICS=1
else # Linux
    bindkey "$key[Up]" history-beginning-search-backward
    bindkey "$key[Down]" history-beginning-search-forward
fi

# Make the command left and right work with iTerm2
# https://coderwall.com/p/a8uxma/zsh-iterm2-osx-shortcuts
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1;5D" beginning-of-line # CSI u
bindkey "^[[1;5C" end-of-line # CSI u

# Make delete work to delete a char.
bindkey "^[[3~" delete-char

# Setup copypaste
x-copy() {
    zle copy-region-as-kill    
    if command -v pbcopy &> /dev/null; then
      print -rn -- $CUTBUFFER | pbcopy
    else
      print -rn -- $CUTBUFFER | xclip -sel CLIPBOARD -in
    fi
}
zle -N x-copy

x-cut() {
    zle kill-region
    if command -v pbcopy &> /dev/null; then
      print -rn -- $CUTBUFFER | pbcopy
    else 
      print -rn -- $CUTBUFFER | xclip -sel CLIPBOARD -in
    fi
}
zle -N x-cut

x-paste() {    
    if command -v pbpaste &> /dev/null; then      
      PASTE=$(pbpaste)
      LBUFFER="$LBUFFER$PASTE"
    else 
      PASTE=$(xclip -sel CLIPBOARD -out)
      LBUFFER="$LBUFFER$PASTE"
    fi
}
zle -N x-paste

# Copy to be mapped from Ctrl+C in Terminal App
# e.g. in kitty.conf: map ctrl+c send_text all \x1bcopy
bindkey "^[copy" x-copy 
bindkey "^X" x-cut
bindkey "^V" x-paste

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
autoload -Uz compinit
compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''

if whence dircolors >/dev/null; then # On Linux
  eval "$(dircolors -b)"
else # On MacOS
  # On Mac LS_COLORS is used only specifically for zsh autocomplete
  # https://superuser.com/questions/290500/zsh-completion-colors-and-os-x  #
  # Tool for translation: https://geoff.greer.fm/lscolors/
  export CLICOLOR=1
  export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
fi
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Experience configuration
# https://wiki.archlinux.org/index.php/zsh#Configure_Zsh
# zstyle ':completion:*' menu select

# Install ZSH Prompt
setopt auto_cd
setopt multios
setopt prompt_subst # enables substitution in prompt
setopt interactive_comments   # allow copypasting scripts with "#" comments
autoload -Uz vcs_info # from git command
source ~/init/zsh-theme/hop-zsh-prompt.sh
# Init plugin for shift-select
source ~/init/zsh-plugins/zsh-shift-select/zsh-shift-select.plugin.zsh
