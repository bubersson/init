## My init scripts

![iTerm screenshot with zsh examples](resources/screenshot.png)

Run following
```sh
cd ~
git clone https://github.com/bubersson/init.git
```

### ZSH Install & Config

Make ZSH the default shell.
```sh
chsh -s $(which zsh)
```

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
# Available colors: https://i.imgur.com/okBgrw4.png
# export MY_MACHINE_COLOR=247 
source ~/init/install.sh
ENDOFFILE
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

Set default git user
```
git config --global user.name "FILL IN"
git config --global user.email FILL@IN.com
```

Setup .gitignore
```
touch ~/.gitignore
cat >> ~/.gitignore << ENDOFFILE
.obsidian/

ENDOFFILE
git config --global core.excludesFile ~/.gitignore
```

Set up automatic updates of `apt`:
https://www.cyberciti.biz/faq/how-to-set-up-automatic-updates-for-ubuntu-linux-18-04/

Make sure `git log` shows inline and does not clear the terminal
```sh
git config --global --replace-all core.pager "less -iXFR"
```

Install Color `cat`
```sh
go get -u github.com/jingweno/ccat
```
```sh
brew install ccat
```

### Mac Only

Install Homebrew.
Go to https://brew.sh/ and run command from there. 
```sh
brew analytics off # disable tracking 
brew-refresh # works if above scripts are properly installed
brew update; brew upgrade
brew install mc curl htop z bash gnupg # cli
brew install golang deno pandoc duf # extended cli
brew install --cask vlc brave-browser veracrypt typora calibre lulu # apps
```

Make brew update automatically
```sh
brew tap domt4/autoupdate
brew autoupdate --start 43200 # update every 12 hours
```

Show brew apps dependency tree
```sh
brew deps --tree --installed
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

#### Elementary OS

Make terminal have black background.
```sh
dconf write /io/elementary/terminal/settings/foreground "'#ddd'"
dconf write /io/elementary/terminal/settings/background "'#000'"
```
Move plank app bar to the left and make it work fast
```sh
dconf write /net/launchpad/plank/docks/dock1/hide-delay "200"
dconf write /net/launchpad/plank/docks/dock1/icon-size "48"
dconf write /net/launchpad/plank/docks/dock1/position "'left'"
dconf write /net/launchpad/plank/docks/dock1/theme "'Matte'"
dconf write /net/launchpad/plank/docks/dock1/unhide-delay "0"
```

Optional: With LCD screens change text size:
```sh

```

Change theme for darker (e.g. for doublecmd)

Download dark theme, e.g. https://www.gnome-look.org/p/1302313
Unpack it and copy gtk-2.0 folder to 
`/usr/share/themes/io.elementary.stylesheet.blueberry/`

**Switch to deep sleep.**
Descriptions: https://learnubuntumate.weebly.com/draining-battery.html
Update `/sys/power/mem_sleep` to include deep sleep
```sh
code /etc/default/grub
# and there 
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash mem_sleep_default=deep"
```
and then confirm (in brackets is the selected one)
```sh
λ cat /sys/power/mem_sleep
s2idle [deep]
```

## Updating

Just run 
```sh
cd ~/init ; git pull
```

## Other ideas / tricks
* https://darrenburns.net/posts/tools/
