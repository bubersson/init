# vim:ft=zsh ts=2 sw=2 sts=2
#
# Hop is a ZSH Theme based on agnoster's Theme
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](https://iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# If using with "light" variant of the Solarized color schema, set
# SOLARIZED_THEME variable to "light". If you don't specify, we'll assume
# you're using the "dark" variant.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'

case ${SOLARIZED_THEME:-dark} in
    light) CURRENT_FG='white';;
    *)     CURRENT_FG='black';;
esac

# Available colors: https://i.imgur.com/okBgrw4.png.

PROMPT_CONTEXT_USERNAME='254'
PROMPT_CONTEXT_HOST='247'
PROMPT_CONTEXT_BG='238'
PROMPT_DIR_FG='14'
PROMPT_DIR_BG='235'

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
  SEGMENT_SEPARATOR=$'\ue0b0'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR\n"
  else
    echo -n "%{%k%}$SEGMENT_SEPARATOR\n"
  fi
  echo -n "%{%f%}λ"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local host_color
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then    
    if [[ -n $MY_MACHINE_COLOR ]]; then
      host_color=$MY_MACHINE_COLOR
    else
      host_color=$PROMPT_CONTEXT_HOST 
    fi    
    prompt_segment $PROMPT_CONTEXT_BG PROMPT_CONTEXT_USERNAME "%n%{%F{$host_color}%}@$MY_MACHINE_NAME"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR="⑂" # $'\ue0a0' # 
  }
  local branch state remote dirty  
  
  repo_path=$(git rev-parse --git-dir 2>&1)    
  if [ $? -eq 0 ]; then
      git_status="$(git status 2> /dev/null)"
      branch_pattern="^[# ]*On branch ([[:print:]]*)" # For ZSH added "\$" instead of "$". ([^${IFS}]*)
      detached_branch_pattern="# Not currently on any branch"
      remote_pattern="[# ]*Your branch is (.*) of"
      diverge_pattern="[# ]*Your branch and (.*) have diverged"
      untracked_pattern="[# ]*Untracked files:"
      new_pattern="new file:"
      not_staged_pattern="[# ]*Changes not staged for commit"
      to_be_commited="[# ]*Changes to be committed:"

      # changes to be commited (no files to be added)
      if [[ ${git_status} =~ ${to_be_commited} ]]; then
          state=" •"
          dirty=1
      fi

      #files not staged for commit
      if [[ ${git_status} =~ ${not_staged_pattern} ]]; then
          state=" ⭑"
          dirty=1
      fi

      # add an else if or two here if you want to get more specific
      # show if we're ahead or behind HEAD
      if [[ ${git_status} =~ ${remote_pattern} ]]; then
          dirty=1
          if [[ $match[1] == "ahead" ]]; then
              remote=" ↑"
          else
              remote=" ↓"
          fi
      fi
      #new files
      if [[ ${git_status} =~ ${new_pattern} ]]; then
          dirty=1
          remote=" +"
      fi
      #untracked files
      if [[ ${git_status} =~ ${untracked_pattern} ]]; then
          dirty=1
          remote=" ?"
      fi
      #diverged branch
      if [[ ${git_status} =~ ${diverge_pattern} ]]; then
          dirty=1
          remote=" ↕"
      fi
      #branch name
      if [[ ${git_status} =~ ${branch_pattern} ]]; then
          branch=$match[1] # ${BASH_REMATCH[1]} for bash
      #detached branch
      elif [[ ${git_status} =~ ${detached_branch_pattern} ]]; then
          branch="NO BRANCH"
      fi
      #merge mode
      if [[ -e "${repo_path}/BISECT_LOG" ]]; then
        mode=" <B>"
      elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
        mode=" >M<"
      elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
        mode=" >R>"
      fi
      #segment color
      if [[ -n $dirty ]]; then
        prompt_segment yellow black
      else
        prompt_segment green $CURRENT_FG
      fi
      echo -n "${PL_BRANCH_CHAR} ${branch}${state}${remote}${mode}"          
  fi
}

prompt_bzr() {
  (( $+commands[bzr] )) || return

  # Test if bzr repository in directory hierarchy
  local dir="$PWD"
  while [[ ! -d "$dir/.bzr" ]]; do
    [[ "$dir" = "/" ]] && return
    dir="${dir:h}"
  done

  local bzr_status status_mod status_all revision
  if bzr_status=$(bzr status 2>&1); then
    status_mod=$(echo -n "$bzr_status" | head -n1 | grep "modified" | wc -m)
    status_all=$(echo -n "$bzr_status" | head -n1 | wc -m)
    revision=$(bzr log -r-1 --log-format line | cut -d: -f1)
    if [[ $status_mod -gt 0 ]] ; then
      prompt_segment yellow black "bzr@$revision ✚"
    else
      if [[ $status_all -gt 0 ]] ; then
        prompt_segment yellow black "bzr@$revision"
      else
        prompt_segment green black "bzr@$revision"
      fi
    fi
  fi
}

prompt_hg() {
  (( $+commands[hg] )) || return
  local rev st branch
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        prompt_segment green $CURRENT_FG
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if `hg st | grep -q "^\?"`; then
        prompt_segment red black
        st='±'
      elif `hg st | grep -q "^[MA]"`; then
        prompt_segment yellow black
        st='±'
      else
        prompt_segment green $CURRENT_FG
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment $PROMPT_DIR_BG $PROMPT_DIR_FG '%~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local -a symbols

  # original:
  #[[ $RETVAL -ne 0 ]] && symbols+="%{%K{red}%}%{%F{white}%}✘"
  #[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  #[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"
  #[[ -n "$symbols" ]] && prompt_segment black default "$symbols"

  # my new state:
  [[ $RETVAL -ne 0 ]] && prompt_segment red black "✘"
  [[ $UID -eq 0 ]] && prompt_segment yellow black "⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && prompt_segment cyan black "⚙"
}

#AWS Profile:
# - display current AWS_PROFILE name
# - displays yellow on red if profile name contains 'production' or
#   ends in '-prod'
# - displays black on green otherwise
prompt_aws() {
  [[ -z "$AWS_PROFILE" ]] && return
  case "$AWS_PROFILE" in
    *-prod|*production*) prompt_segment red yellow  "AWS: $AWS_PROFILE" ;;
    *) prompt_segment green black "AWS: $AWS_PROFILE" ;;
  esac
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
#   prompt_virtualenv
#   prompt_aws
  prompt_context  
  prompt_git
#   prompt_bzr
  prompt_hg
  prompt_dir
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
