export GIT_TERMINAL_PROMPT=1

function parse_git_branch {
    git rev-parse --git-dir > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        git_status="$(git status 2> /dev/null)"
        branch_pattern="^[# ]*On branch ([^${IFS}]*)"
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
        fi
 
        #files not staged for commit
        if [[ ${git_status} =~ ${not_staged_pattern} ]]; then
            state=" ⁕"
        fi
 
        # add an else if or two here if you want to get more specific
        # show if we're ahead or behind HEAD
        if [[ ${git_status} =~ ${remote_pattern} ]]; then
            if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
                remote=" ↑"
            else
                remote=" ↓"
            fi
        fi
        #new files
        if [[ ${git_status} =~ ${new_pattern} ]]; then
            remote=" +"
        fi
        #untracked files
        if [[ ${git_status} =~ ${untracked_pattern} ]]; then
            remote=" ?"
        fi
        #diverged branch
        if [[ ${git_status} =~ ${diverge_pattern} ]]; then
            remote=" ↕"
        fi
        #branch name
        if [[ ${git_status} =~ ${branch_pattern} ]]; then
            branch=${BASH_REMATCH[1]}
        #detached branch
        elif [[ ${git_status} =~ ${detached_branch_pattern} ]]; then
            branch="NO BRANCH"
        fi
 
        echo " (${branch}${state}${remote})"
    fi
    return
}
 
function gittree() {
    git log --branches --remotes --tags --graph --oneline --decorate --max-count=${1:-'25'} 
}
 
function gitlog() {
    git log --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --max-count=${1:-'25'}
}
 
function gitfff() {
    git diff --stat ${1:-'master'}
}

function gitcme() {
    git add .
    git commit -a -m ${1:-'[autoupdate]'}
    git push
}