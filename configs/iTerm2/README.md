# iTerm2 Keyboard bindings
## Installation
`Open iTerm2 > Preferences > Keys > Key Bindings > Presets > Import`

## Details
This includes reasonable defaults to work with keyboard in the shell. The config includes sending escape or hex chars for some common keyboard shortcuts. 

This whole thing is stupid, but bare with me. 

The Flow is
`Keyboard > cmd+d > iTerm (maps to 0x4) > shell > micro (maps to "Ctrl-d":  "SpawnMultiCursor")`

It also includes couple made up escapechars that the app in the terminal needs to know how to handle, i.e.:
```sh
    "\u001bshiftctrld": "DuplicateLine",
    "\u001bshiftctrls": "VSplit",
    "\u001bctrltilde": "NextSplit,NextTab"
```
