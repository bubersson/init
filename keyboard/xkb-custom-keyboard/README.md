# Custom XKB Keyboard

Modified XKB keyboard that provides ~MacOS experience on Dell XPS running Linux. 

## Set up
```
cd [wherever you downloaded the file]
sudo ln -s hopkeyboard /usr/share/X11/xkb/symbols/hopkeyboard
```

## Test it
```
setxkbmap hopkeyboard
```

## Install it forever

Update `/usr/share/X11/xkb/rule/evdev.xml` and add following (e.g. under the english tree).
```xml
<variant>
    <configItem>
        <name>hopkeyboard</name>
        <description>English (US, with Mac friendly touches)</description>
    </configItem>
</variant>
```

Now you can select it as a keyboard layout in the GNOME UI. 

Optionally update
```
/etc/default/keyboard
```
to say
```
XKBLAYOUT=hopkeyboard
```

## Other tutorials
Tutorials:
 - https://askubuntu.com/questions/510024/what-are-the-steps-needed-to-create-new-keyboard-layout-on-ubuntu
 - https://unix.stackexchange.com/questions/202883/create-xkb-configuration-from-xmodmap
 - https://www.charvolant.org/doug/xkb/html/node5.html
 - https://www.x.org/releases/X11R7.6/doc/xorg-docs/input/XKB-Config.- html
 - https://medium.com/@damko/a-simple-humble-but-comprehensive-guide-to-xkb-for-linux-6f1ad5e13450
Examples:
 - https://github.com/nakal/xmonad-conf/blob/f25e81bf16d212b35dfe69765a135787c09c4b7b/xkb/us_alt
 - https://unix.stackexchange.com/questions/205226/xkb-make-ctrlbackspace-behave-as-delete
