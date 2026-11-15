## Set up global paths

# Deduplicate PATH automatically in Zsh
if [ -n "$ZSH_VERSION" ]; then
    typeset -U path PATH
fi

_path_prepend() {
    PATH=":${PATH}:"
    PATH="${PATH//:$1:/:}"
    PATH="${PATH#:}"
    PATH="${PATH%:}"
    export PATH="$1${PATH:+:$PATH}"
}

_path_append() {
    case ":${PATH}:" in
        *":$1:"*) ;;
        *) export PATH="${PATH:+$PATH:}$1" ;;
    esac
}

# Prepend Homebrew paths on MacOS so Homebrew binaries take precedence over /usr/bin
if [[ "$OSTYPE" == darwin* ]]; then
    [ -d /opt/homebrew/sbin ] && _path_prepend "/opt/homebrew/sbin"
    [ -d /opt/homebrew/bin ] && _path_prepend "/opt/homebrew/bin"
fi

# GOROOT is the location where the Go package is installed on your system.
#   export GOROOT=/usr/local/go
# Or create:
#   ln -s /usr/local/go/bin/go /usr/local/bin/go

# Set GOPATH (otherwise defaults to $HOME/go)
# GOPATH is the work directory of your go project.
export GOPATH="$HOME/go"

# Allow go programs being executable globally.
_path_append "$GOPATH/bin"
# _path_append "$GOROOT/bin"

# Allow my scripts to be executed globally
_path_append "$HOME/init/scripts"

# Add executable path for AppImages
_path_append "$HOME/Applications"

# Add .local/bin
_path_append "$HOME/.local/bin"

unset -f _path_prepend _path_append
