## My init scripts

Run following
```sh
cd ~
git clone https://github.com/bubersson/init.git
mkdir src
```

Append following into .bashrc
```
# Install all my aliases, bindings, etc. 
source ~/init/install.sh
```

Finally, re-source .bashrc
```
source ~/.bashrc
```
