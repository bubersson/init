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

Update
```
/etc/default/keyboard
```
to say
```
XKBLAYOUT=hopkeyboard
```
