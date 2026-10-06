#!/bin/zsh
# Copypaste, selection, and clipboard integration for Zsh and Ghostty

# Disable flow control so Cmd+S/Ctrl+S never freezes terminal
stty -ixon 2>/dev/null

# ------------------------------------------------------------------------------
# 1. Selection Collapse (GUI Text Editor Style)
# ------------------------------------------------------------------------------
# In GUI editors, pressing Right collapses to the rightmost boundary (max),
# and pressing Left collapses to the leftmost boundary (min).
shift-select::collapse-to-left() {
  if (( REGION_ACTIVE )); then
    if (( MARK < CURSOR )); then
      CURSOR=$MARK
    fi
    zle deactivate-region -w
  fi
  zle -K main
}
zle -N shift-select::collapse-to-left

shift-select::collapse-to-right() {
  if (( REGION_ACTIVE )); then
    if (( MARK > CURSOR )); then
      CURSOR=$MARK
    fi
    zle deactivate-region -w
  fi
  zle -K main
}
zle -N shift-select::collapse-to-right

bindkey -M shift-select '^[[D' shift-select::collapse-to-left
bindkey -M shift-select '^[OD' shift-select::collapse-to-left
[[ -n "${terminfo[kcub1]}" ]] && bindkey -M shift-select "${terminfo[kcub1]}" shift-select::collapse-to-left

bindkey -M shift-select '^[[C' shift-select::collapse-to-right
bindkey -M shift-select '^[OC' shift-select::collapse-to-right
[[ -n "${terminfo[kcuf1]}" ]] && bindkey -M shift-select "${terminfo[kcuf1]}" shift-select::collapse-to-right

# ------------------------------------------------------------------------------
# 2. Paste Integration
# ------------------------------------------------------------------------------
# Disable visual highlight on pasted text
zle_highlight+=(paste:none)

# Pasting replaces active selection (matches native text editor behavior)
bracketed-paste-replace() {
  if (( REGION_ACTIVE )); then
    zle kill-region
  fi
  zle -K main 2>/dev/null || true
  zle .bracketed-paste
}
zle -N bracketed-paste bracketed-paste-replace
bindkey -M shift-select "^[[200~" bracketed-paste

# ------------------------------------------------------------------------------
# 3. Kitty Keyboard Protocol (Prompt-Scoped)
# ------------------------------------------------------------------------------
# Enable Kitty keyboard protocol flag 1 only while at the interactive prompt (precmd),
# and restore standard legacy keyboard mode before running external commands (preexec).
# This prevents pagers (like `less` in `git diff`), editors, and CLI tools from
# having their arrow keys or key repeat swallowed.
if [[ -t 1 ]] && [[ -n "$TERM" ]] && [[ "$TERM" != "dumb" ]]; then
  autoload -Uz add-zsh-hook 2>/dev/null
  _enable_kitty_keyboard() {
    [[ -t 1 ]] && printf '\e[>1u'
  }
  _disable_kitty_keyboard() {
    [[ -t 1 ]] && printf '\e[<u'
  }
  add-zsh-hook precmd _enable_kitty_keyboard 2>/dev/null
  add-zsh-hook preexec _disable_kitty_keyboard 2>/dev/null
  add-zsh-hook zshexit _disable_kitty_keyboard 2>/dev/null
fi

# ------------------------------------------------------------------------------
# 4. Select All (Cmd+A / Ctrl+A)
# ------------------------------------------------------------------------------
select-all() {
  MARK=0
  CURSOR=${#BUFFER}
  REGION_ACTIVE=1
  zle -K shift-select 2>/dev/null || true
  zle redisplay 2>/dev/null || true
}
zle -N select-all
bindkey "^A" select-all
bindkey -M shift-select "^A" select-all
bindkey "^[[97;9u" select-all
bindkey -M shift-select "^[[97;9u" select-all

# ------------------------------------------------------------------------------
# 5. Copy & Cut (Local Tools + OSC 52 over SSH)
# ------------------------------------------------------------------------------
x-osc52-copy() {
  if (( REGION_ACTIVE )); then
    local start=$(( MARK < CURSOR ? MARK : CURSOR ))
    local end=$(( MARK > CURSOR ? MARK : CURSOR ))
    local text="${BUFFER[start+1,end]}"
    CUTBUFFER="$text"
    if command -v pbcopy &> /dev/null; then
      print -rn -- "$text" | pbcopy 2>/dev/null
    elif [[ -n "$WAYLAND_DISPLAY" ]] && command -v wl-copy &> /dev/null; then
      print -rn -- "$text" | wl-copy 2>/dev/null
    elif [[ -n "$DISPLAY" ]] && command -v xclip &> /dev/null; then
      print -rn -- "$text" | xclip -sel CLIPBOARD -in 2>/dev/null
    fi
    if command -v base64 &> /dev/null; then
      local b64=$(print -rn -- "$text" | base64 2>/dev/null | tr -d '\r\n')
      printf '\e]52;c;%s\a' "$b64" > /dev/tty 2>/dev/null || printf '\e]52;c;%s\a' "$b64" 2>/dev/null
    fi
    REGION_ACTIVE=1
  else
    [[ "$KEYS" == $'\x03' ]] && zle send-break
  fi
}
zle -N x-osc52-copy

x-osc52-cut() {
  if (( REGION_ACTIVE )); then
    zle kill-region
    if command -v pbcopy &> /dev/null; then
      print -rn -- "$CUTBUFFER" | pbcopy 2>/dev/null
    elif [[ -n "$WAYLAND_DISPLAY" ]] && command -v wl-copy &> /dev/null; then
      print -rn -- "$CUTBUFFER" | wl-copy 2>/dev/null
    elif [[ -n "$DISPLAY" ]] && command -v xclip &> /dev/null; then
      print -rn -- "$CUTBUFFER" | xclip -sel CLIPBOARD -in 2>/dev/null
    fi
    if command -v base64 &> /dev/null; then
      local b64=$(print -rn -- "$CUTBUFFER" | base64 2>/dev/null | tr -d '\r\n')
      printf '\e]52;c;%s\a' "$b64" > /dev/tty 2>/dev/null || printf '\e]52;c;%s\a' "$b64" 2>/dev/null
    fi
    zle -K main 2>/dev/null || true
    zle -R 2>/dev/null || true
  fi
}
zle -N x-osc52-cut

# Bind Cmd+C (Ghostty CSI u ^[[99;9u) and Ctrl+C
bindkey "^C" x-osc52-copy
bindkey -M shift-select "^C" x-osc52-copy
bindkey "^[[99;9u" x-osc52-copy
bindkey -M shift-select "^[[99;9u" x-osc52-copy

# Bind Cmd+X (Ghostty CSI u ^[[120;9u), Ctrl+X
bindkey "^X" x-osc52-cut
bindkey -M shift-select "^X" x-osc52-cut
bindkey "^[[120;9u" x-osc52-cut
bindkey -M shift-select "^[[120;9u" x-osc52-cut
