## My init scripts

Run following
```sh
cd ~
git clone https://github.com/bubersson/init.git
```

### ZSH Install & Config

Create files and folders
```sh
mkdir src    # my common folder
touch .zshrc # creates the file if it does not exist. 
```

Following appends to end of .zshrc (update the machine name)
```sh
cat >> .zshrc << ENDOFFILE
### Install all my aliases, bindings, etc. ###
### See https://github.com/bubersson/init  ###
export MY_MACHINE_NAME=pro2
source ~/init/install.sh
ENDOFFILE
```

Install oh-my-zsh
```sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Modify following lines in the .zshrc
```sh
ZSH_THEME="hop"
plugins=(git z)
export MY_MACHINE_NAME=pro2
source $ZSH/oh-my-zsh.sh
```

Optional: Install zsh autosuggestions and code highlighting
zsh-syntax-highlighting (run this after executing zsh again), via https://medium.com/tech-notes-and-geek-stuff/install-zsh-on-arch-linux-manjaro-and-make-it-your-default-shell-b0098b756a7a
```sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
```sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 
```

Create a link to the hop zsh theme `ln -s target(existing) destination(new link)`
```sh
ln -s ~/init/zsh-theme/hop.zsh-theme  ~/.oh-my-zsh/custom/themes/hop.zsh-theme
```

If the characters show up as questionmarsk in a box, then just in iTerm select
`Profiles > Text > Use built-in Powerline glyphs`. The trick is to make sure your terminal app is using fonts that support powerlines. 

Or follow:
- https://raspberrypi.stackexchange.com/questions/34255/special-characters-show-as-question-marks-in-the-shell
- https://stackoverflow.com/questions/42271657/oh-my-zsh-showing-weird-character-on-terminal
- `sudo dpkg-reconfigure locales`
- `sudo apt-get install fonts-powerline`
(this was issue on Raspberry)


On Linux install Powerline fonts
```sh
cd ~/src
git clone https://github.com/powerline/fonts.git
cd fonts; .install.sh
```

Set up automatic updates of `apt`:
https://www.cyberciti.biz/faq/how-to-set-up-automatic-updates-for-ubuntu-linux-18-04/

Make sure `git log` shows inline and does not clear the terminal
```sh
git config --global --replace-all core.pager "less -iXFR"
```

### OLD: Bash version

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

Make brew update automatically
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

Fix Home and End behavior on MacOS (so it doesn't scroll to the top and bottom of the page)
* https://apple.stackexchange.com/questions/18016/can-i-change-the-behavior-of-the-home-and-end-keys-on-an-apple-keyboard-with-num

Disable scaling for mouse.
```sh
defaults write -g com.apple.mouse.scaling -1
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
sudo apt-get install htop mc curl fonts-powerline
```
Install z: https://github.com/rupa/z


Disable sounds
```sh
sudo mv /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga{,.backup}
sudo mv /usr/share/sounds/elementary/stereo/audio-volume-change.wav{,.backup}
```

## Updating

Just run 
```sh
cd ~/init ; git pull
```

## Other ideas / tricks
* https://darrenburns.net/posts/tools/

