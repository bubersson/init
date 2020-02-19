## My init scripts

Run following
```sh
cd ~
git clone https://github.com/bubersson/init.git
```

Create files and folders
```sh
mkdir src
touch .bashrc # creates the file if it does not exist. 
touch .bash_profile # is executed before terminal starts
echo "if [ -f ~/.bashrc ]; then . ~/.bashrc; fi " > .bash_profile
```

Following appends to end of .bashrc
```sh
cat >> .bashrc << ENDOFFILE
### Install all my aliases, bindings, etc. ###
### See https://github.com/bubersson/init  ###
export MY_MACHINE_NAME=pro2
source ~/init/install.sh
ENDOFFILE
```

Finally, re-source .bashrc
```
source ~/.bashrc
```

### Mac Only

Install Homebrew.
Go to https://brew.sh/ and run command from there. 
```sh
brew-refresh # works if above scripts are properly installed
brew update; brew upgrade
brew install mc curl htop golang z bash
```

Make brew update automatially
```sh
brew tap domt4/autoupdate
brew autoupdate --start 43200 # update every 12 hours
```

Make the MacOS dock autohide fast.
```sh
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.25
killall Dock
```

Transfer iterm2 preferences. First get old preferences from `~/.config/iterm2` (or whatever configured folder), then move those to new laptop:
```
cd .config ; mkdir iterm2
```
In iterm2 go to `Preferences > General > Preferences` and enable both loading and saving from the folder (may need to copypaste the hidden path).

The preferences include making ⌘+left, ⌘+right work, also can be found here:
* https://coderwall.com/p/dapstw/keybindings-for-macosx-users-on-iterm2
* https://unix.stackexchange.com/questions/300091/use-mac-os-command-key-in-bashs-bind-command



### Linux Only
```sh
sudo apt-get install htop mc curl
```
Install z: https://github.com/rupa/z

## Updating

Just run 
```sh
cd ~/init ; git pull
```

## Other ideas / tricks
* https://darrenburns.net/posts/tools/

