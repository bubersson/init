# Custom XKB Keyboard

Modified XKB keyboard that provides ~MacOS experience on Dell XPS running Linux. 

## Set up
```
cd /usr/share/X11/xkb/symbols 
sudo ln -s ~/init/keyboard/xkb-custom-keyboard/hopkeyboard hopkeyboard
```

## Test it
```
setxkbmap hopkeyboard
```

## Install it forever

Update
```
/etc/default/keyboard
```
to say
```
XKBLAYOUT=hopkeyboard
```

Although for GNOME we may have to use dconf. TBD to figure that out. 