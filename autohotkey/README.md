# AHK scripts

the main point of those scripts is to try and replicate hyprland functionality in windows.  

* [kill-window](./kill-window.ahk) simply kills the window under the cursor when hitting win+c
* [special-workspace](./special-workspace.ahk) allows you to toggle the view of 2 different terminals by win + m/n (1 for coding the other for testing). you can modify the terminal variable for your own terminal
* [caps-esc-swap](./caps-esc-swap.ahk) simply swaps caps and esc keys.
* [compiler](./compile.ps1) compiles all the AHK scripts to an exe

> [!Note]  
>
> files suffixed by .dep are dropped and won't be included in the [windows-installer](../windows.install.yaml)  
> the installer will put them into the shell:startup folder to run at startup.
