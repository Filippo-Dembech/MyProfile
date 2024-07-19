# MY PROFILE

This script called `profile.ps1` can be used as Powershell profile. It adds a homepage interface where the client can choose among different options.

## Color Theme
This `profile.ps1` script uses iTerm2 colors schemes (files with the `.itermcolors` extension).

Before starting to use iTerm2 colors, [ColorTool](https://github.com/Microsoft/Terminal/tree/main/src/tools/ColorTool) has to be installed.

In order to use an iTerm2 color scheme put its name in the `C:\Program Files\PowerShell\my_profile\color_schemes\default\color_scheme.txt` file. For example, if you want to use the `Breeze.itermcolors` color scheme write it - with also the `.itermcolors` extension - in the `color_scheme.txt` file in the `color_schemes\default` folder. In this way the choosen color scheme will automatically used when Powershell profile starts.


## Homepage

Inside the `profile.ps1` script are defined the `Get-Homepage` function and its `homepage` alias.

This command is automatically run when the `profile.ps1` script run and it gives you the ability to access the homepage interface whenever you want.


## Custom Scripts

When the `profile.ps1` script runs at start-up all the scripts saved in the `C:\Program Files\PowerShell\my_profile\scripts` folder are _dot sourced_ automatically. In this way all the functions, aliases and variables defined in those scripts will be automatically loaded into the session.


## NOTES
- Currently the options are hard-coded and the client has to add them to the `$unsortedOptions` variable and use the `Option` class which accepts a description of the option, a list of shortcuts that will be shown near the option description and a scriptblock with the code to execute when the option is selected. This hard-coded solution will be replaced by a more flexible one in the future.
