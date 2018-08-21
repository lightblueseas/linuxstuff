## disable os shortcuts when idea is running


new python script for intellij that blocks os shortcuts when intellij is running and work fluently without conflicts.


inspired from 
<a rel="noopener" target="_blank" href="https://askubuntu.com/questions/862957/block-unity-keyboard-shortcuts-when-a-certain-application-is-active">askubuntu</a>

## Lubuntu users

you can set it to the autostart in the LXSession configuration with following command:

```shell
/bin/bash -c "sleep 15 && python3 ~/git/linuxstuff/src/main/scripts/python/disable_shortcuts.py"
```
if this not works replace ~ with the real path.
