export GIT_TERMINAL_PROMPT=1
 
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

function gitcm() {
    git add .
    git commit -a -m ${1:-'[autoupdate]'} 
}
