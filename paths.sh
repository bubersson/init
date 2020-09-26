## Set up global paths

# GOROOT is the location where the Go package is installed on your system.
#   export GOROOT=/usr/local/go
# Or create:
#   ln -s /usr/local/go/bin/go /usr/local/bin/go


# Set GOPATH (otherwise defaults to $HOME/go)
# GOPATH is the work directory of your go project.
export GOPATH=$HOME/go

# Allow go programs being executable globally. 
export PATH=$PATH:$GOPATH/bin
# export PATH=$PATH:$GOROOT/bin

# Allow my scripts to be executed globally
export PATH=$PATH:~/init/scripts/
