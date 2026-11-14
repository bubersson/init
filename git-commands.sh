export GIT_TERMINAL_PROMPT=1

function _git_default_branch() {
    local ref
    if ref=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null); then
        echo "${ref#origin/}"
    elif git show-ref --verify --quiet refs/heads/main 2>/dev/null; then
        echo "main"
    elif git show-ref --verify --quiet refs/heads/master 2>/dev/null; then
        echo "master"
    elif git show-ref --verify --quiet refs/remotes/origin/main 2>/dev/null; then
        echo "origin/main"
    else
        echo "master"
    fi
}

function gittree() {
    git log --branches --remotes --tags --graph --oneline --decorate --max-count="${1:-25}"
}

function gitlog() {
    git log --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --max-count="${1:-25}"
}

function gitfff() {
    local target="${1:-$(_git_default_branch)}"
    git diff --stat "$target"
}

function gitcme() {
    git add . &&
    git commit -s -m "${1:-[autoupdate]}" &&
    git push
}

function gitcm() {
    git add . &&
    git commit -s -m "${1:-[autoupdate]}"
}
