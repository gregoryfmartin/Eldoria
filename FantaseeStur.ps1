using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

Enum GlobalGameState {
    Initialize
    SplashScreenAStarting
    SplashScreenARunning
    SplashScreenAEnding
    SplashScreenBStarting
    SplashScreenBRunning
    SplashScreenBEnding
    TitleScreenStarting
    TitleScreenRunning
    TitleScreenEnding
    PlayerSetupScreenStarting
    PlayerSetupScreenRunning
    PlayerSetupScreenEnding
    GamePlayScreenStarting
    GamePlayScreenRunning
    GamePlayScreenEnding
    InventoryScreenStarting
    InventoryScreenRunning
    InventoryScreenEnding
    Cleanup
}

Enum GamePlayState {
    Normal
    Battle
    Shop
    Inn
    Inventory
}

Enum PlayerStatState {
    Normal
    Caution
    Danger
}

Enum TtySpeed {
    SuperSlow = 1000000
    Slow      = 750000
    Normal    = 100000
    Moderate  = 75000
    Quick     = 65000
    Fast      = 50000
    SuperFast = 25000
    LineClear = 1
}

Enum Notes {
    C = 0
    CSharpOrDFlat
    D
    DSharpOrEFlat
    E
    F
    FSharpOrGFlat
    G
    GSharpOrAFlat
    A
    ASharpOrBFlat
    B
    Rest = 37
}

Enum Octaves {
    First = 0
    Second
    Third
    Fourth
    Fifth
    Sixth
    Seventh
    Eighth
    Ninth
}

Enum NoteDuration {
    Whole     = 1600
    Half      = 800
    Quarter   = 400
    Eighth    = 200
    Sixteenth = 100
}

# SCREEN STATE BUFFERS
[BufferCell[,]]$Script:ScreenBufferA = New-Object 'BufferCell[,]' 80, 80
[BufferCell[,]]$Script:ScreenBufferB = New-Object 'BufferCell[,]' 80, 80

# GAMEPLAY SCREEN DRAW DIRTY FLAGS
[Boolean]$Script:GsddSwBorder     = $true
[Boolean]$Script:GsddSwPlayerName = $true
[Boolean]$Script:GsddSwPlayerHp   = $true
[Boolean]$Script:GsddSwPlayerMp   = $true
[Boolean]$Script:GsddSwPlayerGold = $true
[Boolean]$Script:GsddCwBorder     = $true
[Boolean]$Script:GsddCwDiv        = $true
[Boolean]$Script:GsddSwBorder     = $true
[Boolean]$Script:GsddSwImage      = $true
[Boolean]$Script:GsddMwBorder     = $true

# GLOBAL GAME STATE FLAGS
[Boolean]$Script:GssAllowUserInput        = $false
[Boolean]$Script:GssPlayerDataInitialized = $false

# PLAYER DEFINITION VARIABLES
[String]             $Script:PlayerName          = ''
[Int]                $Script:PlayerChp           = 0
[Int]                $Script:PlayerMhp           = 0
[Int]                $Script:PlayerCmp           = 0
[Int]                $Script:PlayerMmp           = 0
[Int]                $Script:PlayerCg            = 0
[Single]             $Script:PlayerSntCaution    = 0.6D
[Single]             $Script:PlayerSntDanger     = 0.2D
[PlayerStatState]    $Script:PlayerHpState       = [PlayerStatState]::Normal
[PlayerStatState]    $Script:PlayerMpState       = [PlayerStatState]::Normal
[ConsoleColor]       $Script:PlayerSdcName       = 9
[ConsoleColor]       $Script:PlayerSdcNumSafe    = 10
[ConsoleColor]       $Script:PlayerSdcNumCaution = 14
[ConsoleColor]       $Script:PlayerSdcNumDanger  = 12
[ConsoleColor]       $Script:PlayerSdcGold       = 6
[ConsoleColor]       $Script:PlayerSdcAside      = 3
[Coordinates]        $Script:PlayerMapCoords     = [Coordinates]::new(0, 0)
[List[MapTileObject]]$Script:PlayerInv           = [List[MapTileObject]]::new()

# SCENE IMAGE DEFINITION VARIABLES
[Int]$Script:SiWidth  = 46
[Int]$Script:SiHeight = 18
# [Int]$Script:SiDrawX  = 32
# [Int]$Script:SiDrawY  = 2

# STATUS WINDOW DEFINITION VARIABLES
[ConsoleColor]$Script:UiSwBorderColor          = 15
[String]      $Script:UiSwBorderHoriz          = '@--~---~---~---~---@'
[String]      $Script:UiSwBorderVert           = '|'
[Int]         $Script:UiSwWinWidth             = 19
[Int]         $Script:UiSwWinHeight            = 11
[Coordinates] $Script:UiSwWinDrawCoords        = [Coordinates]::new(1, 1)
[Coordinates] $Script:UiSwPlayerNameDrawCoords = [Coordinates]::new(2, 2)
[Coordinates] $Script:UiSwPlayerHpDrawCoords   = [Coordinates]::new(2, 4)
[Coordinates] $Script:UiSwPlayerMpDrawCoords   = [Coordinates]::new(2, 6)
[Coordinates] $Script:UiSwPlayerGDrawCoords    = [Coordinates]::new(2, 9)

# COMMAND WINDOW DEFINITION VARIABLES
[ConsoleColor]$Script:UiCwBorderColor     = 15
[ConsoleColor]$Script:UiCwHistValid       = 10
[ConsoleColor]$Script:UiCwHistErr         = 12
[ConsoleColor]$Script:UiCwBlankColor      = 0
[ConsoleColor]$Script:UiCwHistAColor      = 15
[ConsoleColor]$Script:UiCwHistBColor      = 15
[ConsoleColor]$Script:UiCwHistCColor      = 15
[ConsoleColor]$Script:UiCwHistDColor      = 15
[String]      $Script:UiCwBorderHoriz     = '@--~---~---~---~---@'
[String]      $Script:UiCwBorderVert      = '|'
[String]      $Script:UiCwDiv             = '``````````````````'
[String]      $Script:UiCwCmdActual       = ''
[String]      $Script:UiCwCmdBlank        = '                  '
[String]      $Script:UiCmdHistStrA       = ''
[String]      $Script:UiCmdHistStrB       = ''
[String]      $Script:UiCmdHistStrC       = ''
[String]      $Script:UiCmdHistStrD       = ''
[Int]         $Script:UiCwWinWidth        = 19
[Int]         $Script:UiCwWinHeight       = 7
[Coordinates] $Script:UiCwWinDrawCoords   = [Coordinates]::new(1, 12)
[Coordinates] $Script:UiCwDivDrawCoords   = [Coordinates]::new($Script:UiCwWinDrawCoords.X + 1, ($Script:UiCwWinDrawCoords.Y + $Script:UiCwWinHeight) - 2)
[Coordinates] $Script:UiCwHistDDrawCoords = [Coordinates]::new($Script:UiCwWinDrawCoords.X + 1, ($Script:UiCwWinDrawCoords.Y + $Script:UiCwWinHeight) - 3)
[Coordinates] $Script:UiCwHistCDrawCoords = [Coordinates]::new($Script:UiCwWinDrawCoords.X + 1, ($Script:UiCwWinDrawCoords.Y + $Script:UiCwWinHeight) - 4)
[Coordinates] $Script:UiCwHistBDrawCoords = [Coordinates]::new($Script:UiCwWinDrawCoords.X + 1, ($Script:UiCwWinDrawCoords.Y + $Script:UiCwWinHeight) - 5)
[Coordinates] $Script:UiCwHistADrawCoords = [Coordinates]::new($Script:UiCwWinDrawCoords.X + 1, ($Script:UiCwWinDrawCoords.Y + $Script:UiCwWinHeight) - 6)

# SCENE WINDOW DEFINITION VARIABLES
[ConsoleColor]$Script:UiScwBorderColor     = 15
[String]      $Script:UiScwBorderHoriz     = '@-<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>-@'
[String]      $Script:UiScwBorderVert      = '|'
[Int]         $Script:UiScwWidth           = 50
[Int]         $Script:UiScwHeight          = 19
[Coordinates] $Script:UiScwWinDrawCoords   = [Coordinates]::new(30, 1)
[Coordinates] $Script:UiScwImageDrawCoords = [Coordinates]::new(32, 2)

# MESSAGE WINDOW DEFINITION VARIABLES
[ConsoleColor]$Script:UiMwBorderColor         = 15
[ConsoleColor]$Script:UiMwMsgAColor           = 15
[ConsoleColor]$Script:UiMwMsgBColor           = 15
[ConsoleColor]$Script:UiMwMsgCColor           = 15
[ConsoleColor]$Script:UiMwBlankColor          = 0
[String]      $Script:UiMwBorderHoriz         = '-'
[String]      $Script:UiMwBorderVert          = '|'
[String]      $Script:UiMwMsgBlank            = '                                                                             '
[String]      $Script:UiMwMsgStrA             = ''
[String]      $Script:UiMwMsgStrB             = ''
[String]      $Script:UiMwMsgStrC             = ''
[Int]         $Script:UiMwWinWidth            = 80
[Int]         $Script:UiMwWinHeight           = 5
[Coordinates] $Script:UiMwWinDrawCoords       = [Coordinates]::new(1, 20)
[Coordinates] $Script:UiMwMsgBottomDrawCoords = [Coordinates]::new($Script:UiMwWinDrawCoords.X + 1, 23)
[Coordinates] $Script:UiMwMsgMiddleDrawCoords = [Coordinates]::new($Script:UiMwWinDrawCoords.X + 1, 22)
[Coordinates] $Script:UiMwMsgTopDrawCoords    = [Coordinates]::new($Script:UiMwWinDrawCoords.X + 1, 21)

# GENERAL GLOBAL VARIABLES
[String]     $Script:OsCheckLinux        = 'OsLinux'
[String]     $Script:OsCheckMac          = 'OsMac'
[String]     $Script:OsCheckWindows      = 'OsWindows'
[String]     $Script:OsCheckUnknown      = 'OsUnknown'
[Coordinates]$Script:DefaultCursorCoords = [Coordinates]::new($Script:UiCwWinDrawCoords.X + 1, $Script:UiCwDivDrawCoords.Y + 1)

$Script:Rui = $(Get-Host).UI.RawUI

# SCENE IMAGES
$Script:SceneImageSample = New-Object 'BufferCell[,]' $Script:SiHeight, $Script:SiWidth
$Script:SiFieldNRoad     = New-Object 'BufferCell[,]' $Script:SiHeight, $Script:SiWidth
$Script:SiFieldNERoad    = New-Object 'BufferCell[,]' $Script:SiHeight, $Script:SiWidth
$Script:SiFieldNWRoad    = New-Object 'BufferCell[,]' $Script:SiHeight, $Script:SiWidth
$Script:SiFieldNEWRoad   = New-Object 'BufferCell[,]' $Script:SiHeight, $Script:SiWidth
$Script:SiFieldSRoad     = New-Object 'BufferCell[,]' $Script:SiHeight, $Script:SiWidth
$Script:SiFieldSERoad    = New-Object 'BufferCell[,]' $Script:SiHeight, $Script:SiWidth
$Script:SiFieldSWRoad    = New-Object 'BufferCell[,]' $Script:SiHeight, $Script:SiWidth
$Script:SiFieldSEWRoad   = New-Object 'BufferCell[,]' $Script:SiHeight, $Script:SiWidth





# FUNCTION DEFINITIONS

<#
.SYNOPSIS
Returns a preformatted string to display the Player's hit point information.
#>
Function Format-PlayerHitPoints {
    [CmdletBinding()]
    Param ()

    Process {
        Return "H $($Script:PlayerChp) `n`t/ $($Script:PlayerMhp)"
    }
}

<#
.SYNOPSIS
Returns a preformatted string to display the Player's magic point information.
#>
Function Format-PlayerMagicPoints {
    [CmdletBinding()]
    Param ()

    Process {
        Return "M $($Script:PlayerCmp) `n`t/ $($Script:PlayerMmp)"
    }
}

<#
.SYNOPSIS
Returns a preformatted string to display the Player's gold information.
#>
Function Format-PlayerGold {
    [CmdletBinding()]
    Param ()

    Process {
        Return "$($Script:PlayerCg)G"
    }
}

<#
.SYNOPSIS
Creates a new Scene Image with random garbage. This is intended to be used for testing purposes only.
#>
Function New-SceneImageRandom {
    [CmdletBinding()]
    Param ()

    Process {
        For($h = 0; $h -LT $Script:SiHeight; $h++) {
            For($w = 0; $w -LT $Script:SiWidth; $w++) {
                [Int]$randBgColor = Get-Random -Minimum 1 -Maximum 15 # Exclude black
                $Script:SceneImageSample[$h, $w] = [BufferCell]::new(' ', 0, $randBgColor, 0)
            }
        }
    }
}

<#
.SYNOPSIS
Writes a Scene Image to the Scene Image "Window".

.DESCRIPTION
This function takes a two-dimensional array of BufferCell objects and writes them to the console buffer in the position where the Scene Image "Window" exists at.

Originally, this function was tested on MacOS and Linux, where most of the functions in the RawUI instance are crippled. So a manual method of writing the cells was devised.
After coming back to testing this function on Windows - where all of the functionality of the RawUI instance is available - a multi-platform algorithm was devised.
The function now takes a switch that controls which algorithm is used. It should be noted that of the two, the Windows-specific algorithm is substantially faster and works as expected.

.PARAMETER CellArray
The two-dimensional array of BufferCell objects that represent the Scene Image that are going to be written to the console buffer. The drawing origin coordinates are predefined.
#>
Function Write-SceneImage {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [BufferCell[,]]$CellArray
    )

    Process {
        Switch($(Test-Os)) {
            { $_ -EQ $Script:OsCheckLinux -OR $_ -EQ $Script:OsCheckMac } {
                For($h = 0; $h -LT $Script:SiHeight; $h++) {
                    For($w = 0; $w -LT $Script:SiWidth; $w++) {
                        $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiScwImageDrawCoords.X + $w, $Script:UiScwImageDrawCoords.Y + $h)
                        Write-Host ' ' -BackgroundColor $CellArray[$h, $w].BackgroundColor -NoNewline
                    }
                }
            }

            { $_ -EQ $Script:OsCheckWindows } {
                $Script:Rui.SetBufferContents($Script:UiScwImageDrawCoords, $CellArray)
            }

            Default {}
        }
    }
}

Function Test-Os {
    [CmdletBinding()]
    Param ()

    Process {
        Get-PSDrive -Name Variable | Out-Null
        If ($?) {
            Get-ChildItem Variable:/IsLinux | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsLinux).Value -EQ $true) {
                    Return $Script:OsCheckLinux
                }
            }

            Get-ChildItem Variable:/IsMacOS | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsMacOS).Value -EQ $true) {
                    Return $Script:OsCheckMac
                }
            }

            Get-ChildItem Variable:/IsWindows | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsWindows).Value -EQ $true) {
                    Return $Script:OsCheckWindows
                }
            }
        }

        Return $Script:OsCheckUnknown
    }
}

<#
.SYNOPSIS
A wrapper for Write-Host that utilizes the NoNewline switch, which is a common requirement for a lot of console write calls in this module.
#>
Function Write-HostNnl {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [ConsoleColor]$ForegroundColor,
        [Parameter(Mandatory = $false)]
        [ConsoleColor]$BackgroundColor = 0
    )

    Process {
        Write-Host $Message -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    }
}

<#
.SYNOPSIS
Sets the console cursor position to the predefined "default" location. This is mostly to get it out of the way for visual aesthetic.
#>
Function Set-DefaultCursorPosition {
    [CmdletBinding()]
    Param ()

    Process {
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoords
    }
}

<#
.SYNOPSIS
Writes a string to the console buffer at a caller-specified cell coordinate location. This function will leverate Write-GfmHostNnl to perform the write operation.

.PARAMETER Coordinates
The Coordinates (in console cells) where the string will start to be written to.

.PARAMETER Message
The string to write to the console.

.PARAMETER ForegroundColor
The color to give to the string when it's being written.
#>
Function Write-PositionalString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Coordinates]$Coordinates,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [ConsoleColor]$ForegroundColor
    )

    Process {
        $Script:Rui.CursorPosition = $Coordinates
        Write-HostNnl -Message $Message -ForegroundColor $ForegroundColor
    }
}

<#
.SYNOPSIS
Writes a string to the console in a teletype fashion. This function will leverage Write-GfmHostNnl.

.PARAMETER Message
The string that will be written to the console.

.PARAMETER ForegroundColor
The color to give to the string when it's being written.

.PARAMETER TypeSpeed
The speed at which to type the characters of the Message to the console at. By default, this is [TtySpeed]:: Normal.
#>
Function Write-TtyString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [ConsoleColor]$ForegroundColor,
        [Parameter(Mandatory = $false)]
        [TtySpeed]$TypeSpeed = [TtySpeed]::Normal
    )

    Process {
        [Char[]]$msgCharArray = $Message.ToCharArray()
        [Int]$typeCounter     = 0
        [Int]$msgcaProbe      = 0
        
        While($msgcaProbe -LE ($msgCharArrayl.Count - 1)) {
            $typeCounter++
            If($typeCounter -GE $TypeSpeed) {
                $typeCounter = 0
                Write-HostNnl -Message $msgCharArray[$msgcaProbe] -ForegroundColor $ForegroundColor
                $msgcaProbe++
            }
        }
    }
}

<#
.SYNOPSIS
Combines the positional string and teletype functions.

.PARAMETER Coordinates
The Coordinates (in console cells) where the string will start to be written to.

.PARAMETER Message
The string that will be written to the console.

.PARAMETER ForegroundColor
The color to give to the string when it's being written.

.PARAMETER TypeSpeed
The speed at which to type the characters of the Message to the console at. By default, this is [TtySpeed]:: Normal.
#>
Function Write-PositionalTtyString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Coordinates]$Coordinates,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [ConsoleColor]$ForegroundColor,
        [Parameter(Mandatory = $false)]
        [TtySpeed]$TypeSpeed = [TtySpeed]::Normal
    )

    Process {
        $Script:Rui.CursorPosition = $Coordinates
        Write-TtyString -Message $Message -ForegroundColor $ForegroundColor -TypeSpeed $TypeSpeed
    }
}

<#
.SYNOPSIS
Writes the Player's Name to the console window at the predefined cell coordinates.
#>
Function Write-PlayerName {
    [CmdletBinding()]
    Param ()

    Process {
        Write-PositionalString `
            -Coordinates $Script:UiSwPlayerNameDrawCoords `
            -Message $Script:PlayerName `
            -ForegroundColor $Script:PlayerSdcName
    }

    End {
        Set-DefaultCursorPosition
    }
}

<#
.SYNOPSIS
Writes the Player's Hit Points to the console window at the predefined cell coordinates.
#>
Function Write-PlayerHp {
    [CmdletBinding()]
    Param ()

    Process {
        Switch($Script:PlayerHpState) {
            ([PlayerStatState]::Normal) {
                Write-PositionalString `
                    -Coordinates $Script:UiSwPlayerHpDrawCoords `
                    -Message $(Format-PlayerHitPoints) `
                    -ForegroundColor $Script:PlayerSdcNumSafe
            }

            ([PlayerStatState]::Caution) {
                Write-PositionalString `
                    -Coordinates $Script:UiSwPlayerHpDrawCoords `
                    -Message $(Format-PlayerHitPoints) `
                    -ForegroundColor $Script:PlayerSdcNumCaution
            }

            ([PlayerStatState]::Danger) {
                Write-PositionalString `
                -Coordinates $Script:UiSwPlayerHpDrawCoords `
                -Message $(Format-PlayerHitPoints) `
                -ForegroundColor $Script:PlayerSdcNumDanger
            }

            Default {
                Write-PositionalString `
                -Coordinates $Script:UiSwPlayerHpDrawCoords `
                -Message $(Format-PlayerHitPoints) `
                -ForegroundColor $Script:PlayerSdcNumDanger
            }
        }
    }

    End {
        Set-DefaultCursorPosition
    }
}

<#
.SYNOPSIS
Writes the Player's Magic Points to the console window at the predefined cell coordinates.
#>
Function Write-PlayerMp {
    [CmdletBinding()]
    Param ()

    Process {
        Switch($Script:PlayerMpState) {
            ([PlayerStatState]::Normal) {
                Write-PositionalString `
                    -Coordinates $Script:UiSwPlayerMpDrawCoords `
                    -Message $(Format-PlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerSdcNumSafe
            }

            ([PlayerStatState]::Caution) {
                Write-PositionalString `
                    -Coordinates $Script:UiSwPlayerMpDrawCoords `
                    -Message $(Format-PlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerSdcNumCaution
            }

            ([PlayerStatState]::Danger) {
                Write-PositionalString `
                -Coordinates $Script:UiSwPlayerMpDrawCoords `
                -Message $(Format-PlayerMagicPoints) `
                -ForegroundColor $Script:PlayerSdcNumDanger
            }

            Default {
                Write-PositionalString `
                -Coordinates $Script:UiSwPlayerMpDrawCoords `
                -Message $(Format-PlayerMagicPoints) `
                -ForegroundColor $Script:PlayerSdcNumDanger
            }
        }
    }

    End {
        Set-DefaultCursorPosition
    }
}

<#
.SYNOPSIS
Writes the Player's gold information to the console at the predefined cell coordinates.
#>
Function Write-PlayerGold {
    [CmdletBinding()]
    Param ()

    Process {
        Write-PositionalString `
            -Coordinates $Script:UiSwPlayerGDrawCoords `
            -Message $Script:PlayerCg `
            -ForegroundColor $Script:PlayerSdcGold
    }

    End {
        Set-DefaultCursorPosition
    }
}

<#
.SYNOPSIS
Tests the Player's current hit points against a fraction of the maximum and determines the state accordingly.
#>
Function Test-PlayerHpForState {
    [CmdletBinding()]
    Param ()

    Process {
        If($Script:PlayerChp -GT ($Script:PlayerMhp * $Script:PlayerSntCaution)) {
            $Script:PlayerHpState = [PlayerStatState]::Normal
        } Elseif(($Script:PlayerChp -GT ($Script:PlayerMhp * $Script:PlayerSntDanger)) -AND ($Script:PlayerChp -LT ($Script:PlayerMhp * $Script:PlayerSntCaution))) {
            $Script:PlayerHpState = [PlayerStatState]::Caution
        } Elseif($Script:PlayerChp -LT ($Script:PlayerMhp * $Script:PlayerSntDanger)) {
            $Script:PlayerHpState = [PlayerStatState]::Danger
        }
    }
}

<#
.SYNOPSIS
Tests the Player's current magic points against a fraction of the maximum and determines the state accordingly.
#>
Function Test-PlayerMpForState {
    [CmdletBinding()]
    Param ()

    Process {
        If($Script:PlayerCmp -GT ($Script:PlayerMmp * $Script:PlayerSntCaution)) {
            $Script:PlayerMpState = [PlayerStatState]::Normal
        } Elseif(($Script:PlayerCmp -GT ($Script:PlayerMmp * $Script:PlayerSntDanger)) -AND ($Script:PlayerCmp -LT ($Script:PlayerMmp * $Script:PlayerSntCaution))) {
            $Script:PlayerMpState = [PlayerStatState]::Caution
        } Elseif($Script:PlayerCmp -LT ($Script:PlayerMmp * $Script:PlayerSntDanger)) {
            $Script:PlayerMpState = [PlayerStatState]::Danger
        }
    }
}

<#
.SYNOPSIS
Changes the player's name and writes it to the console window if applicable.

.PARAMETER NewName
The new name to assign to the player.

.PARAMETER WriteToConsole
Writes the name to the console at the predefined cell coordinates if necessary.
#>
Function Update-PlayerName {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$NewName,
        [Switch]$WriteToConsole
    )

    Process {
        $Script:PlayerName = $NewName
        If($WriteToConsole) {
            Write-PlayerName
        }
    }
}

<#
.SYNOPSIS
Updates the player's current hit points and writes it to the console window if applicable.

.PARAMETER Delta
The additive to the current hit points value. To subtract from the current hit points, assign this a negative value.

.PARAMETER WriteToConsole
Writes the HP String to the console at the predefined cell coordinates if necessary.
#>
Function Update-PlayerHp {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$Delta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerChp + $Delta
        $t = [Math]::Clamp($t, 0, $Script:PlayerMhp)
        $Script:PlayerChp = $t
        Test-PlayerHpForState
        If($WriteToConsole) {
            Write-PlayerHp
        }
    }
}

<#
.SYNOPSIS
Updates the player's current magic points and writes it to the console window if applicable.

.PARAMETER Delta
The additive to the current magic points value. To subtract from the current magic points, assign this a negative value.

.PARAMETER WriteToConsole
Writes the MP String to the console at the predefined cell coordinates if necessary.
#>
Function Update-PlayerMp {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$Delta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerCmp + $Delta
        $t = [Math]::Clamp($t, 0, $Script:PlayerMmp)
        $Script:PlayerCmp = $t
        Test-PlayerHpForState
        If($WriteToConsole) {
            Write-PlayerMp
        }
    }
}

<#
.SYNOPSIS
Updates the player's current gold points and writes it to the console window if applicable.

.PARAMETER Delta
The additive to the current gold points value. To subtract from the current gold points, assign this a negative value.

.PARAMETER WriteToConsole
Writes the Gold String to the console at the predefined cell coordinates if necessary.
#>
Function Update-PlayerGold {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$Delta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerCg + $Delta
        $t = [Math]::Clamp($t, 0, [Int]::MaxValue)
        $Script:PlayerCg = $t
        If($WriteToConsole) {
            Write-PlayerGold
        }
    }
}

<#
.SYNOPSIS
Writes a message to the Message Window Area

.PARAMETER Message
The message to add to the Message Window "queue".

.PARAMETER Teletype
Specifies if we're going to use the teletype method for printing the message to the window.
#>
Function Write-MsgWinMessage {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Message,
        [Parameter(Mandatory = $false)]
        [ConsoleColor]$ForegroundColor = 15,
        [Switch]$Teletype
    )

    Process {
        $Script:UiMwMsgAColor = $Script:UiMwMsgBColor; $Script:UiMwMsgStrA = $Script:UiMwMsgStrB
        $Script:UiMwMsgBColor = $Script:UiMwMsgCColor; $Script:UiMwMsgStrB = $Script:UiMwMsgStrC
        $Script:UiMwMsgCColor = $ForegroundColor; $Script:UiMwMsgStrC      = $Message
        
        If($Teletype) {
            Write-PositionalString `
                -Coordinates $Script:UiMwMsgBottomDrawCoords `
                -Message $Script:UiMwMsgBlank `
                -ForegroundColor $Script:UiMwBlankColor
            Write-PositionalTtyString `
                -Coordinates $Script:UiMwMsgBottomDrawCoords `
                -Message $Script:UiMwMsgStrC `
                -ForegroundColor $Script: UiMwMsgCColor
            Write-PositionalString `
                -Coordinates $Script:UiMwMsgMiddleDrawCoords `
                -Message $Script:UiMwMsgBlank `
                -ForegroundColor $Script:UiMwBlankColor
            Write-PositionalTtyString `
                -Coordinates $Script:UiMwMsgMiddleDrawCoords `
                -Message $Script:UiMwMsgStrB `
                -ForegroundColor $Script: UiMwMsgBColor
            Write-PositionalString `
                -Coordinates $Script:UiMwMsgTopDrawCoords `
                -Message $Script:UiMwMsgBlank `
                -ForegroundColor $Script:UiMwBlankColor
            Write-PositionalTtyString `
                -Coordinates $Script:UiMwMsgTopDrawCoords `
                -Message $Script:UiMwMsgStrA `
                -ForegroundColor $Script:UiMwMsgAColor
        } Else {
            Write-PositionalString `
                -Coordinates $Script:UiMwMsgBottomDrawCoords `
                -Message $Script:UiMwMsgBlank `
                -ForegroundColor $Script:UiMwBlankColor
            Write-PositionalString `
                -Coordinates $Script:UiMwMsgBottomDrawCoords `
                -Message $Script:UiMwMsgStrC `
                -ForegroundColor $Script: UiMwMsgCColor
            Write-PositionalString `
                -Coordinates $Script:UiMwMsgMiddleDrawCoords `
                -Message $Script:UiMwMsgBlank `
                -ForegroundColor $Script:UiMwBlankColor
            Write-PositionalString `
                -Coordinates $Script:UiMwMsgMiddleDrawCoords `
                -Message $Script:UiMwMsgStrB `
                -ForegroundColor $Script: UiMwMsgBColor
            Write-PositionalString `
                -Coordinates $Script:UiMwMsgTopDrawCoords `
                -Message $Script:UiMwMsgBlank `
                -ForegroundColor $Script:UiMwBlankColor
            Write-PositionalString `
                -Coordinates $Script:UiMwMsgTopDrawCoords `
                -Message $Script:UiMwMsgStrA `
                -ForegroundColor $Script:UiMwMsgAColor
        }
    }

    End {
        Set-DefaultCursorPosition
    }
}

Function Read-UserCommandInput {
    [CmdletBinding()]
    Param ()

    Process {
        $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        While($keyCap.VirtualKeyCode -NE 13) {
            If($Script:Rui.CursorPosition.X -GE 19) {
                Invoke-CommandParser
            }
            If($keyCap.VirtualKeyCode -EQ 8) {
                $fx = $Script:Rui.CursorPosition.X
                If($fx -GE $Script:DefaultCursorCoords.X) {
                    Write-HostNnl `
                        -Message ' ' `
                        -ForegroundColor 0 `
                        -BackgroundColor 0
                    $Script:Rui.CursorPosition = [Coordinates]::new($fx - 1, $Script:DefaultCursorCoords.Y)
                    If($Script:UiCwCmdActual.Length -GT 0) {
                        $Script:UiCwCmdActual = $Script:UiCwCmdActual.Remove($Script:UiCwCmdActual.Lenth - 1, 1)
                    }
                } Else {
                    Write-GfmPositionalString `
                        -Coordinates $([Coordinates]::new($fx + 1, $Script:DefaultCursorCoords.Y)) `
                        -Message ' ' `
                        -ForegroundColor 0
                    Set-DefaultCursorPosition
                    If($Script:UiCwCmdActual.Length -GT 0) {
                        $Script:UiCwCmdActual = $Script:UiCwCmdActual.Remove($Script:UiCwCmdActual.Lenth - 1, 1)
                    }
                }
            } Else {
                $Script:UiCwCmdActual += $keyCap.Character
            }
            $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        }

        Invoke-CommandParser
    }
}

Function Invoke-CommandParser {
    [CmdletBinding()]
    Param ()

    Process {
        Set-DefaultCursorPosition
        Write-HostNnl `
            -Message $Script:UiCwCmdBlank `
            -ForegroundColor 0
        If([String]::IsNullOrEmpty($Script:UiCwCmdActual)) {
            Set-DefaultCursorPosition
            Return
        } Else {
            $cmdactSplit = -Split $Script:UiCwCmdActual
            $rootFound   = $Script:CommandTable.GetEnumerator() | Where-Object { $_.Name -IEQ $cmdactSplit[0] }
            if($null -NE $rootFound) {
                Switch($cmdactSplit.Length) {
                    1 {
                        Invoke-Command $rootFound.Value
                    }

                    2 {
                        Invoke-Command $rootFound.Value -ArgumentList $cmdactSplit[1]
                    }

                    3 {
                        Invoke-Command $rootFound.Value -ArgumentList $cmdactSplit[1], $cmdactSplit[2]
                    }

                    Default {
                        Invoke-Command $rootFound.Value
                    }
                }
            } Else {
                Write-BadCommandException
                Return
            }
        }
    }
}

Function Invoke-ItemReactor {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$ItemName
    )

    Process {
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        If($a.Count -EQ 0) {
            Update-CmdHistory -CmdValid
            Write-MapNoItemsFoundException
            Return
        } Elseif($a.Count -GT 0) {
            Foreach($c in $a) {
                If($c.MapObjName -EQ $ItemName) {
                    Update-CmdHistory -CmdValid
                    Invoke-Command $c.Effect
                    Return
                }
            }
            Update-CmdHistory -CmdValid
            Write-MapInvalidItemException -ItemName $ItemName
            Return
        } Else {
            Write-BadSomethingException
            Return
        }
    }
}

Function Invoke-LookAction {
    [CmdletBinding()]
    Param ()

    Process {
        Update-CmdHistory -CmdValid
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        $b = 78
        $c = ''
        $f = ''
        $z = 0
        $y = $false

        If($a.Count -LE 0) {
            Write-MsgWinMessage `
                -Message 'It doesn''t look like there''s anything of interest here.' `
                -ForegroundColor $Script:PlayerSdcAside `
                -Teletype
            Return
        }
        Foreach($d in $a) {
            If($z -EQ $a.Count - 1) {
                $c += $d.Name
            } Else {
                $c += $d.Name + ', '
            }
            $z++
        }
        $e = $c.Length
        If($e -GT $b) {
            $y = $true
            $c -MATCH '([\s,]+\w+){5}$' | Out-Null
            If($_ -EQ $true) {
                $c = $c -REPLACE '([\s,]+\w+){5}$', ''
                $f = $matches[0].Remove(0, 2)
            }
        }
        Write-MsgWinMessage `
            -Message 'I can see the following things here: ' `
            -ForegroundColor $Script:PlayerSdcAside `
            -Teletype
        Write-MsgWinMessage `
            -Message $c `
            -ForegroundColor 15 `
            -Teletype
        If($y -EQ $true) {
            Write-MsgWinMessage `
                -Message $f `
                -ForegroundColor 15 `
                -Teletype
        }
    }
}

Function Invoke-ExamineAction {
    [CmdletBinding()]
    Param (
        [Parametet(Mandatory = $true)]
        [String]$ItemName
    )

    Process {
        Foreach($a in $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing) {
            If($a.Name -EQ $ItemName) {
                Update-CmdHistory -CmdValid
                Write-MsgWinMessage `
                    -Message $a.ExamineString `
                    -ForegroundColor $Script:PlayerSdcAside `
                    -Teletype
                Return
            }
        }

        Update-CmdHistory -CmdValid
        Write-MsgWinMessage `
            -Message "There's no $ItemName to be found here..." `
            -ForegroundColor $Script:PlayerSdcAside `
            -Teletype
        Return
    }
}

Function Invoke-GetAction {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$ItemName
    )

    Process {
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        If($a.Count -LE 0) {
            Update-CmdHistory
            Write-MsgWinMessage `
                -Message 'There doesn''t appear to be anything to collect here...' `
                -ForegroundColor $Script:PlayerSdcAside `
                -Teletype
            Return
        }
        Foreach($b in $a) {
            If($b.Name -EQ $ItemName) {
                If($b.CanAddToInventory -EQ $true) {
                    $Script:PlayerInv.Add($b) | Out-Null
                    $c = $a.Remove($b) | Out-Null
                    If($c -EQ $false) {
                        Write-Error 'Failed to remove item from MapTile OL!'
                        Exit
                    } Else {
                        Update-CmdHistory -CmdValid
                        Write-MsgWinMessage `
                            -Message "I've taken the $($b.MapObjName) and put it in my pocket." `
                            -Teletype
                        Return
                    }
                } Else {
                    Update-CmdHistory
                    Write-MsgWinMessage `
                        -Message "It's not possible to take the $($b.MapObjName)." `
                        -ForegroundColor $Script:PlayerSdcAside `
                        -Teletype
                    Return
                }
            }
        }
        Update-CmdHistory
        Write-MsgWinMessage `
            -Message "There's no $ItemName to be found here..." `
            -ForegroundColor $Script:PlayerSdcAside `
            -Teletype
        Return
    }
}