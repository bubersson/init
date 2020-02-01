## My init scripts

Run following
```sh
cd ~
git clone https://github.com/bubersson/init.git
```
Optional
```sh
mkdir src
touch .bashrc #if .bashrc does not exist
```

Append following into .bashrc
```
### Install all my aliases, bindings, etc. ###
### See https://github.com/bubersson/init  ###
source ~/init/install.sh
```

Finally, re-source .bashrc
```
source ~/.bashrc
```
