# =============== GENERAL POWERSHELL CONFIGUATIONS ===============
# Remove autosuggestions for Powershell 7
Set-PSReadLineOption -PredictionSource None

# Enable autoloading for all modules in the $env:PSModulePath
$PSModuleAutoloadingPreference = "All"


# =============== COLOR TOOL ===============
$MyProfilePath = "C:\Program Files\Powershell\my_profile"

# check whether ColorTool.exe is installed on the system
$ColorToolExeIsPresent = [bool](Get-Command ColorTool.exe -ErrorAction Ignore)

# check whether the folder 'color_schemes' is present in the Powershell 7 folder
$ColorSchemesDirIsPresent = (Test-Path "\color_schemes")

# check whether the folder 'default' is present in the 'color_scheme' folder
$DefaultFolderIsPresent = (Test-Path "$MyProfilePath\color_schemes\default")

# check whether there is the 'color_scheme.txt' file to export the default color scheme from
$DefaultColorSchemeIsPresent = (Test-Path "$MyProfilePath\color_schemes\default\color_scheme.txt")

if ($ColorToolExeIsPresent -and $ColorSchemesDirIsPresent -and $DefaultFolderIsPresent -and $DefaultColorSchemeIsPresent) {

    $DefaultColorScheme = (Get-Content "$MyProfilePath\color_schemes\default\color_scheme.txt")

    # The '--quiet' option prevents ColorTool from printing the table of the applied color scheme
    ColorTool.exe --quiet "$MyProfilePath\color_schemes\$DefaultColorScheme"
}


# =============== CUSTOM SCRIPTS ===============
# automatically alias the scripts in the Powershell\bin folder to avoid file extensions to appear in the call
$Scripts = Get-ChildItem "$MyProfilePath\scripts"

# define aliases for custom scripts (in this way there is no need of including .ps1 extension at invokation)
foreach ($Script in $Scripts) {

    # dot source all the profile custom scripts
    . $Script.FullName

}


# ================= HOMEPAGE ===================
class Option {
	[string]$Description
	[string[]]$Shortcuts
	[scriptblock]$Action

	Option([string]$Description, [string[]]$Shortcuts, [scriptblock]$Action) {
		$this.Description = $Description
		$this.Shortcuts = $Shortcuts
		$this.action = $Action
	}

	[void] operate() {
		Print-Selection $this.Description
		$this.action.Invoke()
	}
}


# =============== ESCAPING CODE ===============
$ESC = [char]27


<#
.SYNOPSIS
    Displays a homepage with various options for navigation and tasks.

.DESCRIPTION
    The Get-Homepage function presents a user-friendly interface with a banner and a list of options.
    Users can navigate to different directories, open applications, or perform specific tasks by selecting an option.
    Options include shortcuts for quick access and some options prompt the user for further input.

.EXAMPLE
    Get-Homepage
    Displays the homepage, allowing the user to select from a list of predefined options.

#>
function Get-Homepage {

    function Print-Banner {
        Write-Host " ================================================"
        Write-Host "  _____                           _          _ _ " -Foreground Red
        Write-Host " |  __ \                         | |        | | |" -Foreground Red
        Write-Host " | |__) |____      _____ _ __ ___| |__   ___| | |" -Foreground Yellow
        Write-Host " |  ___/ _ \ \ /\ / / _ \ '__/ __| '_ \ / _ \ | |" -Foreground Green
        Write-Host " | |  | (_) \ V  V /  __/ |  \__ \ | | |  __/ | |" -Foreground Cyan
        Write-Host " |_|   \___/ \_/\_/ \___|_|  |___/_| |_|\___|_|_|" -Foreground DarkBlue
        Write-Host " ================================================"
        Write-Host " ************************************************"
        Write-Host " ************************************************"
    }

    function Read-Input {
        param($Prompt)
        
        Write-Host "$($Prompt) $([char]16) " -NoNewLine
        return $Host.UI.ReadLine()
    }

    function Print-Options {
        $pad = 45
        
        [string]$result = ""

        $result += "What do you want to do?`n"

        for ($i = 0; $i -lt $options.length; $i++) {
            $option = $options[$i]

            $shortcuts = $option.shortcuts -join ", "


            if (($i % 2) -eq 1) {
                $result += "$($option.description)($ESC[1m$($shortcuts)$ESC[0m)"
            } else {
                $result += "`n`t$("$($option.description)($ESC[1m$($shortcuts)$ESC[0m)".padRight($pad))"
            }
        }

        $result += "`n`nYour choice:"
        return $result
    }

    function Print-Selection {
        Write-Host "$([char]16) $($args[0]) $([char]17) have been selected"
    }

    Print-Banner

    # =============== Define options ===============
    $unsortedOptions = @(
        [Option]::new("Work", @("w"), {
            Set-Location "~\my_Safe Zone\Utilities\CS\Work In Progress"
        }),
        [Option]::new("Safe Zone", @("s", "sz"), {
            Set-Location "~\my_Safe Zone\Utilities"
        }),
        [Option]::new("Dart Directory", @("d", "dd"), {
            Set-Location "~\my_Safe Zone\Utilities\CS\Work In Progress\Dart"
        }),
        [Option]::new("Powershell Directory", @("ps", "pd", "psd"), {
            Set-Location "~\my_Safe Zone\Utilities\CS\Work In Progress\Powershell"
        }),
        [Option]::new("Projects Directory", @("p", "projects"), {
            Set-Location "~\my_Safe Zone\Utilities\CS\Work In Progress\Projects"
        }),
        [Option]::new("Powershell Profile", @("psp", "profile"), {
            code "C:\Program Files\PowerShell\7\profile.ps1"
            Set-Location $HOME
        }),
        [Option]::new("CDrive", @("c"), {
            Set-Location "C:\"
        }),
        [Option]::new("Home Directory", @("h", "home"), {
            Set-Location $HOME
        }),
        [Option]::new("Anki", @("a"), {
            Start-Job -ScriptBlock {
                Start-Process "~\AppData\Local\Programs\Anki\anki.exe"
            }
        }),
        [Option]::new("YouTube", @("yt"), {
            $search = Read-Input -Prompt "Search for"

            if ($search -eq "my_focus") {
                Start-Process "https://www.youtube.com/playlist?list=PLp5SqSucVsAkQgXvBMjONIqwc9yoE_Sy0" 
            } elseif ($search.Length -gt 0) {
                Start-Process "https://www.youtube.com/results?search_query=$($search)"
            }
            Set-Location $HOME
        }),
        [Option]::new("Google", @("g", "ggl"), {
            $search = Read-Input -Prompt "Search for"
            Start-Process "https://www.google.com/search?q=$($search)"
            }),
        [Option]::new("Google Drive", @("gd", "ggld"), {
            Start-Process "https://drive.google.com/drive/my-drive?lfhs=2"
        }),
        [Option]::new("Current Directory", @("currdir", "currd"), {
            Set-Location $pwd
        }),
        [Option]::new("Bin Directory", @("bin"), {
            Set-Location "~\my_Bin"
        }),
        [Option]::new("Powershell Bin", @("pb", "psb"), {
            Set-Location "~\my_Bin\Powershell\bin"
        }),
        [Option]::new("Desktop", @("desk"), {
            Set-Location "~\Desktop\"
        }),
        [Option]::new("Modules Registry", @("mod", "module"), {
            Set-Location "C:\Program Files\Powershell\Modules"
        }),
        [Option]::new("Current Project", @("cp", "currp"), {
            $selection = Read-Input -Prompt "Open the project [type 'o' or 'open'] or go to the directory [type 'goto']?"
            if (($selection -eq "o") -or ($selection -eq "open")) {
                Open-CurrentProject
                Set-Location $HOME
            }
            if ($selection -eq "goto") {
                Goto-CurrentProject
            }
        }),
    [Option]::new("Apps Script Directory", @("asd", "appscript"), {
        Set-Location "~\my_Safe Zone\Utilities\CS\Work In Progress\Apps Script"
    })
    )

    # =============== Sort options ===============
    $options = $unsortedOptions | Sort-Object -Property Description

    # =============== Get user input ===============
    $selection = Read-Input -Prompt $(Print-Options)

    $userGreetings = @(
        "hi",
        "hi there",
        "hithere",
        "hello",
        "sup",
        "hi there mate",
        "hello mate",
        "how are you?",
        "hi mate",
        "sup?",
        "sup mate?"
    )

    $psGreetings = @(
        "hi there! How are you doing?",
        "Hello! Are you ok?",
        "It's nice to see you again",
        "Hi there mate! Sup?",
        "Oh shit! here we go again. Ready to powercode!?",
        "Hi! Finally someone capable to work with",
        "Hello mate! Long time no see!",
        "Are you ready to rock!?",
        "What took you so long? Are you ready to code?"
    )

    if ($userGreetings -contains $selection) {
        $psGreeting = $psGreetings | Get-Random
        Write-Host "`nPowershell: '$("$ESC[1m$($psGreeting)$ESC[0m")'`n"
        Set-Location $HOME
    } elseif ($selection -eq "exit") {
        Stop-Process -Id $PID -Force
    } else {

        $option = $options | Where-Object {
            ($_.description -eq $selection) -or ($_.shortcuts -contains $selection)
        }

        if ($option -ne $null) {
            $option.operate()
        } else {
            Set-Location $HOME
        }
    }

}

# create an alias to the homepage for later use during the session
Set-Alias -Name homepage -Value Get-Homepage

# prompt the homepage
Get-Homepage


# =============== PROMPT DEFINITION ===============

function prompt {

	function Print-Rainbow {

		param([int]$Length,[String]$Symbol)

        $ColorLength = 0
        
        $ColorLength = ($Length -lt 1) ? (1) : ($Length / 11)
        
        $RainbowColors = @("Red", "Yellow", "Green", "Cyan", "Blue", "Magenta", "Blue", "Cyan", "Green", "Yellow", "Red" )

		$result = ""

        foreach ($Color in $RainbowColors) {
		    $result += "$(Write-Host ($Symbol * $ColorLength) -ForegroundColor $Color -NoNewline)"
        }

		return $result

	}

	$block = [char]22

    $Location = "$ESC[7mPS `u{00BB} $(Get-Location)$ESC[0m"

    $HorizontalBoxChar = [string][char]9552
    $TopLeftBoxChar = [string][char]9556
    $BottomLeftBoxChar = [string][char]9562

    $rainbowParams = @{
        Symbol = $HorizontalBoxChar
        Length = $Host.UI.RawUI.WindowSize.Width / 1.2
    }

    "$(Print-Rainbow @rainbowParams)" +
    "`n$TopLeftBoxChar$HorizontalBoxChar$Location   ┬─┬⃰͡ (ᵔᵕᵔ͜ )" +
	$(if ($NestedPromptLevel -ge 1) { '>>' }) +
	"`n$BottomLeftBoxChar$HorizontalBoxChar$HorizontalBoxChar "
}