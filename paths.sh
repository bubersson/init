## Set up global paths

# Set GOPATH (otherwise defaults to $HOME/go)
export GOPATH=$HOME/src/go

# Allow go programs being executable globally. 
export PATH=$PATH:$GOPATH/bin

# Allow my scripts to be executed globally
export PATH=$PATH:~/init/scripts/
