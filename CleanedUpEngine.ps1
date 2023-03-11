using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

#region ENUMERATION DEFINITIONS

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

Enum PlayerStatNumState {
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

#endregion




#region CLASS DEFINITIONS

Class MapTileObject {
    [String]$Name
    [String]$MapObjName
    [String[]]$ExamineStrings
    [Boolean]$CanAddToInventory
    [ScriptBlock]$Effect

    MapTileObject(
        [String]$Name,
        [String]$MapObjName,
        [String[]]$ExamineStrings,
        [Boolean]$CanAddToInventory,
        [ScriptBlock]$Effect = {}
    ) {
        $this.Name              = $Name
        $this.MapObjName        = $MapObjName
        $this.ExamineStrings    = $ExamineStrings
        $this.CanAddToInventory = $CanAddToInventory
        $this.Effect            = $Effect
    }

    [String]GetRandomExamineString() {
        [Int]$r = $(Get-Random -Minimum 1 -Maximum $($this.ExamineStrings.Length - 1))
        Return $this.ExamineStrings[$r]
    }
}

Class MTOTree : MapTileObject {
    MTOTree(): base('Tree', 'tree', @('It''s a tree. Looks like all the other ones.'), $false, {
        # TODO: Do something with the tree
    }) {}
}

Class MTOLadder : MapTileObject {
    MTOLadder(): base('Ladder', 'ladder', @('Maybe I can climb this ladder?'), $false, {
        # TODO: Do something with the ladder
    }) {}
}

Class MTORope : MapTileObject {
    MTORope(): base('Rope', 'rope', @('A tightly braided and durable rope.'), $false, {
        # TODO: Do something with the rope
    }) {}
}

Class MTOStairs : MapTileObject {
    MTOStairs(): base('Stairs', 'stairs', @('Stairs. A faithful ally for elevating one''s position.'), $false, {
        # TODO: Do something with the stairs
    }) {}
}

Class MTOPole : MapTileObject {
    MTOPole(): base('Pole', 'pole', @('Not the north or the south one. Just a pole. For climbing.'), $false, {
        # TODO: Do something with the pole
    }) {}
}

Class MapTile {
    Static [Int]$TileExitNorth = 0
    Static [Int]$TileExitSouth = 1
    Static [Int]$TileExitEast  = 2
    Static [Int]$TileExitWest  = 3

    [BufferCell[,]]$BackgroundImage
    [Boolean[]]$Exits
    [List[MapTileObject]]$ObjectListing

    MapTile(
        [BufferCell[,]]$BackgroundImage,
        [Boolean[]]$Exits,
        [MapTileObject[]]$ObjectListing
    ) {
        $this.BackgroundImage = $BackgroundImage
        $this.Exits           = $Exits
        $this.ObjectListing   = [List[MapTileObject]]::new()
        
        Foreach($a in $ObjectListing) {
            $this.ObjectListing.Add($a) | Out-Null
        }
    }
}

Class Map {
    [String]$Name
    [Coordinates]$Dimensions
    [Boolean]$BoundaryWarp
    [MapTile[,]]$Tiles

    Map(
        [String]$Name,
        [Coordinates]$Dimensions,
        [Boolean]$BoundaryWarp
    ) {
        $this.Name         = $Name
        $this.Dimensions   = $Dimensions
        $this.BoundaryWarp = $BoundaryWarp
        $This.Tiles = New-Object 'MapTile[,]' $this.Dimensions.Y, $this.Dimensions.X
    }

    [MapTile]GetTileAtPlayerCoordinates() {
        Return $this.Tiles[$Script:PlayerMapCoordinates.Y, $Script:PlayerMapCoordinates.X]
    }
}

#endregion




#region PLAYER VARIABLES

[String]             $Script:PlayerName                 = ''
[Int]                $Script:PlayerCurrentHitPoints     = 0
[Int]                $Script:PlayerMaxHitPoints         = 0
[Int]                $Script:PlayerCurrentMagicPoints   = 0
[Int]                $Script:PlayerMaxMagicPoints       = 0
[Int]                $Script:PlayerCurrentGold          = 0
[Int]                $Script:PlayerMaxGold              = 0
[Single]             $Script:PlayerStatNumTCaution      = 0.6D
[Single]             $Script:PlayerStatNumTDanger       = 0.2D
[PlayerStatNumState] $Script:PlayerHitPointsState       = [PlayerStatNumState]::Normal
[PlayerStatNumState] $Script:PlayerMagicPointsState     = [PlayerStatNumState]::Normal
[ConsoleColor]       $Script:PlayerStatDrawColorName    = 9
[ConsoleColor]       $Script:PlayerStatDrawColorSafe    = 10
[ConsoleColor]       $Script:PlayerStatDrawColorCaution = 14
[ConsoleColor]       $Script:PlayerStatDrawColorDanger  = 12
[ConsoleColor]       $Script:PlayerStatDrawColorGold    = 6
[ConsoleColor]       $Script:PlayerAsideColor           = 3
[Coordinates]        $Script:PlayerMapCoordinates       = [Coordinates]::new(0, 0) # Origin coordinates apply for Maps
[List[MapTileObject]]$Script:PlayerInventory            = [List[MapTileObject]]::new()

#endregion




#region SCENE IMAGE VARIABLES

[Int]        $Script:SceneImageWidth      = 46
[Int]        $Script:SceneImageHeight     = 18
[Coordinates]$Script:SceneImageDrawOrigin = [Coordinates]::new(32, 2)

#endregion




#region STATUS WINDOW VARIABLES

[String]      $Script:UiStatusindowBorderHorizontal      = '@--~---~---~---~---@'
[String]      $Script:UiStatusWindowBorderVertical       = '|'
[ConsoleColor]$Script:UiStatusWindowBorderColor          = 15
[Int]         $Script:UiStatusWindowWidth                = 19
[Int]         $Script:UiStatusWindowHeight               = 11
[Coordinates] $Script:UiStatusWindowDrawOrigin           = [Coordinates]::new(1, 1)
[Coordinates] $Script:UiStatusWindowPlayerNameDrawOrigin = [Coordinates]::new(2, 2)
[Coordinates] $Script:UiStatusWindowPlayerHpDrawOrigin   = [Coordinates]::new(2, 4)
[Coordinates] $Script:UiStatusWindowPlayerMpDrawOrigin   = [Coordinates]::new(2, 6)
[Coordinates] $Script:UiStatusWindowPlayerGoldDrawOirgin = [Coordinates]::new(2, 9)

#endregion




#region COMMAND WINDOW VARIABLES

[String]      $Script:UiCommandWindowBorderHorizontal = '@--~---~---~---~---@'
[String]      $Script:UiCommandWindowBorderVertical   = '|'
[String]      $Script:UiCommandWindowCmdDiv           = '``````````````````'
[String]      $Script:UiCommandWindowCmdActual        = ''
[String]      $Script:UiCommandWindowCmdBlank         = '                  '
[String]      $Script:UiCommandWindowHistStrA         = ''
[String]      $Script:UiCommandWindowHistStrB         = ''
[String]      $Script:UiCommandWindowHistStrC         = ''
[String]      $Script:UiCommandWindowHistStrD         = ''
[ConsoleColor]$Script:UiCommandWindowBorderColor      = 15
[ConsoleColor]$Script:UiCommandWindowCmdValid         = 10
[ConsoleColor]$Script:UiCommandWindowCmdErr           = 12
[ConsoleColor]$Script:UiCommandWindowBlankFgColor     = 0
[ConsoleColor]$Script:UiCommandWindowHistColA         = 15
[ConsoleColor]$Script:UiCommandWindowHistColB         = 15
[ConsoleColor]$Script:UiCommandWindowHistColC         = 15
[ConsoleColor]$Script:UiCommandWindowHistColD         = 15
[Int]         $Script:UiCommandWindowWidth            = 19
[Int]         $Script:UiCommandWindowHeight           = 7
[Coordinates] $Script:UiCommandWindowDrawOrigin       = [Coordinates]::new(1, 12)
[Coordinates] $Script:UiCommandWindowDivDrawOrigin    = [Coordinates]::new(($Script:UiCommandWindowDrawOrigin.X + 1), (($Script:UiCommandWindowDrawOrigin.Y + $Script:UiCommandWindowHeight) - 2))
[Coordinates] $Script:UiCommandWindowHistDDrawOrigin  = [Coordinates]::new(($Script:UiCommandWindowDrawOrigin.X + 1), (($Script:UiCommandWindowDrawOrigin.Y + $Script:UiCommandWindowHeight) - 3))
[Coordinates] $Script:UiCommandWindowHistCDrawOrigin  = [Coordinates]::new(($Script:UiCommandWindowDrawOrigin.X + 1), (($Script:UiCommandWindowDrawOrigin.Y + $Script:UiCommandWindowHeight) - 4))
[Coordinates] $Script:UiCommandWindowHistBDrawOrigin  = [Coordinates]::new(($Script:UiCommandWindowDrawOrigin.X + 1), (($Script:UiCommandWindowDrawOrigin.Y + $Script:UiCommandWindowHeight) - 5))
[Coordinates] $Script:UICommandWindowHistADrawOrigin  = [Coordinates]::new(($Script:UiCommandWindowDrawOrigin.X + 1), (($Script:UiCommandWindowDrawOrigin.Y + $Script:UiCommandWindowHeight) - 6))

#endregion




#region SCENE WINDOW VARIABLES

[String]      $Script:UiSceneWindowBorderHorizontal = '@-<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>-@'
[String]      $Script:UiSceneWindowBorderVertical   = '|'
[ConsoleColor]$Script:UiSceneWindowBorderColor      = 15
[Int]         $Script:UiSceneWindowWidth            = 50
[Int]         $Script:UiSceneWindowHeight           = 19
[Coordinates] $Script:UiSceneWindowDrawOrigin       = [Coordinates]::new(30, 1)

#endregion




#region MESSAGE WINDOW VARIABLES

[String]      $Script:UiMessageWindowBorderHorizontal = '-'
[String]      $Script:UiMessageWindowBorderVertical   = '|'
[String]      $Script:UiMessageWindowMsgAStr          = ''
[String]      $Script:UiMessageWindowMsgBStr          = ''
[String]      $Script:UiMessageWindowMsgCStr          = ''
[String]      $Script:UiMessageWindowMsgBlank         = '                                                                             '
[ConsoleColor]$Script:UiMessageWindowBorderColor      = 15
[ConsoleColor]$Script:UiMessageWindowBlackFgColor     = 0
[ConsoleColor]$Script:UiMessageWindowMsgAColor        = 15
[ConsoleColor]$Script:UiMessageWindowMsgBColor        = 15
[ConsoleColor]$Script:UiMessageWindowMsgCColor        = 15
[Int]         $Script:UiMessageWindowWidth            = 80
[Int]         $Script:UiMessageWindowHeight           = 5
[Coordinates] $Script:UiMessageWindowDrawOrigin       = [Coordinates]::new(1, 20)
[Coordinates] $Script:UiMessageWindowMsgADrawOrigin   = [Coordinates]::new(2, 23)
[Coordinates] $Script:UiMessageWindowMsgBDrawOrigin   = [Coordinates]::new(2, 22)
[Coordinates] $Script:UiMessageWindowMsgCDrawOrigin   = [Coordinates]::new(2, 21)

#endregion




#region TIMING VARIABLES

[Int]      $Script:TargetFrameRate  = 30
[Single]   $Script:MsPerFrame       = 1000 / $Script:TargetFrameRate
[Boolean]  $Script:GameRunning      = $true
[Double]   $Script:LastFrameTime    = 0D
[Double]   $Script:CurrentFrameTime = 0D
[TimeSpan]$Script:FpsDelta          = [TimeSpan]::Zero

#endregion




#region GENERAL VARIABLES

$Script:Rui = $(Get-Host).UI.RawUI

[Coordinates]$Script:DefaultCursorCoords = [Coordinates]::new(($Script:UiCommandWindowDrawOrigin.X + 1), ($Script:UiCommandWindowDivDrawOrigin.Y + 1))
[String]     $Script:OsCheckLinux        = 'OsLinux'
[String]     $Script:OsCheckMac          = 'OsMac'
[String]     $Script:OsCheckWindows      = 'OsWindows'
[String]     $Script:OsCheckUnknown      = 'OsUnknown'

#endregion




#region SCREEN BUFFER VARIABLES

[BufferCell[,]]$Script:ScreenBufferA = New-Object 'BufferCell[,]' 80, 80
[BufferCell[,]]$Script:ScreenBufferB = New-Object 'BufferCell[,]' 80, 80

#endregion




#region MAP VARIABLES

[Map]$Script:SampleMap   = [Map]::new('Sample Map', [Coordinates]::new(2, 2), $true)
[Map]$Script:CurrentMap  = $Script:SampleMap
[Map]$Script:PreviousMap = $null

#endregion




#region FUNCTION DEFINITIONS

#region TEST-GFMOS

<#
.SYNOPSIS
Checks to see what OS the script is running on and returns a script-specific string identifier to be used elsewhere.
#>
Function Test-GfmOs {
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

#endregion

#region TEST-GFMPLAYERHPFORSTATE

<#
.SYNOPSIS
Tests the player's current hit points against a fraction of the maximum and determines their state accordingly.
#>
Function Test-GfmPlayerHpForState {
    [CmdletBinding()]
    Param ()

    Process {
        If($Script:PlayerCurrentHitPoints -GT ($Script:PlayerMaxHitPoints * $Script:PlayerStatNumTCaution)) {
            $Script:PlayerHitPointsState = [PlayerStatNumState]::Normal
        } Elseif(($Script:PlayerCurrentHitPoints -GT ($Script:PlayerMaxHitPoints * $Script:PlayerStatNumTDanger)) -AND ($Script:PlayerCurrentHitPoints -LT ($Script:PlayerMaxHitPoints * $Script:PlayerStatNumTCaution))) {
            $Script:PlayerHitPointsState = [PlayerStatNumState]::Caution
        } Elseif($Script:PlayerCurrentHitPoints -LT ($Script:PlayerMaxHitPoints * $Script:PlayerStatNumTDanger)) {
            $Script:PlayerHitPointsState = [PlayerStatNumState]::Danger
        }
    }
}

#endregion

#region TEST-GFMPLAYERMPFORSTATE

<#
.SYNOPSIS
Tests the player's current magic points against a fraction of the maximum and determines their state accordingly.
#>
Function Test-GfmPlayerMpForState {
    [CmdletBinding()]
    Param ()

    Process {
        If($Script:PlayerCurrentMagicPoints -GT ($Script:PlayerMaxMagicPoints * $Script:PlayerStatNumTCaution)) {
            $Script:PlayerMagicPointsState = [PlayerStatNumState]::Normal
        } Elseif(($Script:PlayerCurrentMagicPoints -GT ($Script:PlayerMaxMagicPoints * $Script:PlayerStatNumTDanger)) -AND ($Script:PlayerCurrentMagicPoints -LT ($Script:PlayerMaxMagicPoints * $Script:PlayerStatNumTCaution))) {
            $Script:PlayerMagicPointsState = [PlayerStatNumState]::Caution
        } Elseif($Script:PlayerCurrentMagicPoints -LT ($Script:PlayerMaxMagicPoints * $Script:PlayerStatNumTDanger)) {
            $Script:PlayerMagicPointsState = [PlayerStatNumState]::Danger
        }
    }
}

#endregion

#region WRITE-GFMHOSTNNL

<#
.SYNOPSIS
A wrapper for Write-Host that utilizes the NoNewline switch, which is a common requirement for a lot of console write calls in this script.
#>
Function Write-GfmHostNnl {
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

#endregion

#region SET-GFMDEFAULTCURSORPOSITION

<#
.SYNOPSIS
Sets the console cursor position to the predefined "default" location.
#>
Function Set-GfmDefaultCursorPosition {
    [CmdletBinding()]
    Param ()

    Process {
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoords
    }
}

#endregion

#region WRITE-GFMPOSITIONALSTRING

<#
.SYNOPSIS
Writes a string to the console buffer at a caller-specified cell coordinate location. This function will leverage Write-GfmHostNnl to perform the write operation.

.PARAMETER Coordinates
The Coordinates (in console cells) where the string will start to be written to.

.PARAMETER Message
The string to write to the console.

.PARAMETER ForegroundColor
The color to give to the text when it's being written.
#>
Function Write-GfmPositionalString {
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
        Write-GfmHostNnl -Message $Message -ForegroundColor $ForegroundColor
    }
}

#endregion

#region WRITE-GFMTTYSTRING

<#
.SYNOPSIS
Writes a string to the console in a teletype fashion. This function will leverage Write-GfmHostNnl.

.PARAMETER Message
The string that will be written to the console.

.PARAMETER ForegroundColor
The color to give to the text when it's being written.

.PARAMETER TypeSpeed
The speed at which to type the characters of the Message to the console at. By default, this is [TtySpeed]::Normal.
#>
Function Write-GfmTtyString {
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
        [Int]   $typeCounter  = 0
        [Int]   $msgcaProbe   = 0

        While($msgcaProbe -LE ($msgCharArray.Count - 1)) {
            $typeCounter++
            If ($typeCounter -GE $TypeSpeed) {
                $typeCounter = 0
                Write-GfmHostNnl -Message $msgCharArray[$msgcaProbe] -ForegroundColor $ForegroundColor
                $msgcaProbe++
            }
        }
    }
}

#endregion

#region WRITE-GFMPOSITIONALTTYSTRING

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
The speed at which to type the characters of the Message to the console at. By default, this is [TtySpeed]::Normal.
#>
Function Write-GfmPositionalTtyString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Coordinates]$Coordinates,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [System.ConsoleColor]$ForegroundColor,
        [Parameter(Mandatory = $false)]
        [TtySpeed]$TypeSpeed = [TtySpeed]::Normal
    )

    Process {
        $Script:Rui.CursorPosition = $Coordinates
        Write-GfmTtyString -Message $Message -ForegroundColor $ForegroundColor -TypeSpeed $TypeSpeed
    }
}

#endregion

#region FORMAT-GFMPLAYERHITPOINTS

<#
.SYNOPSIS
Returns a formatted string to display the player's hit point information. This string doesn't contain coordinate data. The calling function is expected to do this.
#>
Function Format-GfmPlayerHitPoints {
    [CmdletBinding()]
    Param ()

    Process {
        Return "H $($Script:PlayerCurrentHitPoints) `n`t/ $($Script:PlayerMaxHitPoints)"
    }
}

#endregion

#region FORMAT-GFMPLAYERMAGICPOINTS

<#
.SYNOPSIS
Returns a formatted string to display the player's magic point information. This string doesn't contain coordinate data. The calling function is expected to do this.
#>
Function Format-GfmPlayerMagicPoints {
    [CmdletBinding()]
    Param ()

    Process {
        Return "M $($Script:PlayerCurrentMagicPoints) `n`t/ $($Script:PlayerMaxMagicPoints)"
    }
}

#endregion

#region FORMAT-GFMPLAYERGOLD

<#
.SYNOPSIS
Returns a formatted string to display the player's gold information. This string doesn't contain coordinate data. The calling function is expected to do this.
#>
Function Format-GfmPlayerGold {
    [CmdletBinding()]
    Param ()

    Process {
        Return "$($Script:PlayerCurrentGold)G"
    }
}

#endregion

#region WRITE-GFMPLAYERNAME

<#
.SYNOPSIS
Writes the player's name to the console window at the predefined cell coordinates.
#>
Function Write-GfmPlayerName {
    [CmdletBinding()]
    Param ()

    Process {
        Write-GfmPositionalString `
            -Coordinates $Script:UiStatusWindowPlayerNameDrawOrigin `
            -Message $Script:PlayerName `
            -ForegroundColor $Script:PlayerStatDrawColorName
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

#endregion

#region WRITE-GFMPLAYERHP

<#
.SYNOPSIS
Writes the player's hit points - relative to their state - to the console window at the predefined cell coordinates.
#>
Function Write-GfmPlayerHp {
    [CmdletBinding()]
    Param ()

    Process {
        Switch($Script:PlayerHitPointsState) {
            ([PlayerStatNumState]::Normal) {
                Write-GfmPositionalString `
                    -Coordinates $Script:UiStatusWindowPlayerHpDrawOrigin `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatDrawColorSafe
            }

            ([PlayerStatNumState]::Caution) {
                Write-GfmPositionalString `
                    -Coordinates $Script:UiStatusWindowPlayerHpDrawOrigin `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatDrawColorCaution
            }

            ([PlayerStatNumState]::Danger) {
                Write-GfmPositionalString `
                    -Coordinates $Script:UiStatusWindowPlayerHpDrawOrigin `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatDrawColorDanger
            }

            Default {
                Write-GfmPositionalString `
                    -Coordinates $Script:UiStatusWindowPlayerHpDrawOrigin `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatDrawColorSafe
            }
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

#endregion

#region WRITE-GFMPLAYERMP

<#
.SYNOPSIS
Writes the player's magic points - relative to their state - to the console window at the predefined cell coordinates.
#>
Function Write-GfmPlayerMp {
    [CmdletBinding()]
    Param ()

    Process {
        Switch($Script:PlayerMagicPointsState) {
            ([PlayerStatNumState]::Normal) {
                Write-GfmPositionalString `
                    -Coordinates $Script:UiStatusWindowPlayerMpDrawOrigin `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatDrawColorSafe
            }

            ([PlayerStatNumState]::Caution) {
                Write-GfmPositionalString `
                    -Coordinates $Script:UiStatusWindowPlayerMpDrawOrigin `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatDrawColorCaution
            }

            ([PlayerStatNumState]::Danger) {
                Write-GfmPositionalString `
                    -Coordinates $Script:UiStatusWindowPlayerMpDrawOrigin `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatDrawColorDanger
            }

            Default {
                Write-GfmPositionalString `
                    -Coordinates $Script:UiStatusWindowPlayerMpDrawOrigin `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatDrawColorSafe
            }
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

#endregion

#region WRITE-GFMPLAYERGOLD

<#
.SYNOPSIS
Writes the player's gold points to the console window at the predefined cell coordinates.
#>
Function Write-GfmPlayerGold {
    [CmdletBinding()]
    Param ()

    Process {
        Write-GfmPositionalString `
            -Coordinates $Script:UiStatusWindowPlayerGoldDrawOirgin `
            -Message $(Format-GfmPlayerGold) `
            -ForegroundColor $Script:PlayerStatDrawColorGold
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

#endregion

#region NEW-GFMSCENEIMAGESAMPLE

<#
.SYNOPSIS
Creates a new Sample Scene Image. This Scene Image is used for testing purposes only.
#>
Function New-GfmSceneImageSample {
    [CmdletBinding()]
    Param ()

    Process {
        For($h = 0; $h -LT $Script:SceneImageHeight; $h++) {
            For($w = 0; $w -LT $Script:SceneImageWidth; $w++) {
                [Int]$r = Get-Random -Minimum 1 -Maximum 15
                $Script:SceneImageSample[$h, $w] = [BufferCell]::new(' ', 0, $r, 0)
            }
        }
    }
}

#endregion

#region WRITE-GFMSCENEIMAGE

Function Write-GfmSceneImage {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [BufferCell[,]]$CellArray
    )

    Process {
        Switch($(Test-GfmOs)) {
            { $_ -EQ $Script:OsCheckLinux -OR $_ -EQ $Script:OsCheckMac } {
                For($h = 0; $h -LT $Script:SceneImageHeight; $h++) {
                    For($w = 0; $w -LT $Script:SceneImageWidth; $w++) {
                        $Script:Rui.CursorPosition = [Coordinates]::new(($Script:SceneImageDrawOrigin.X + $w), ($Script:SceneImageDrawOrigin.Y + $h))
                        Write-Host ' ' -BackgroundColor $CellArray[$h, $w].BackgroundColor -NoNewline
                    }
                }
            }

            { $_ -EQ $Script:OsCheckWindows } {
                $Script:Rui.SetBufferContents($Script:SceneImageDrawOrigin, $CellArray)
            }

            Default {}
        }
    }
}

#endregion

#region UPDATE-GFMPLAYERNAME

<#
.SYNOPSIS
Changes the player's name and writes it to the console window if applicable.

.PARAMETER NewName
The new name to assign to the player.

.PARAMETER WriteToConsole
Writes the name to the console at the predefined cell coordinates if necessary.
#>
Function Update-GfmPlayerName {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$NewName,
        [Switch]$WriteToConsole
    )

    Process {
        $Script:PlayerName = $NewName
        If($WriteToConsole) {
            Write-GfmPlayerName
        }
    }

    End {
        If($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

#endregion

#region UPDATE-GFMPLAYERHP

<#
.SYNOPSIS
Updates the player's current hit points and writes it to the console window if applicable.

.PARAMETER HpDelta
The additive to the current hit points value. To subtract from the current hit points, assign this a negative value.

.PARAMETER WriteToConsole
Writes the HP String to the console at the predefined cell coordinates if necessary.
#>
Function Update-GfmPlayerHp {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$HpDelta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerCurrentHitPoints + $HpDelta
        $t = [Math]::Clamp($t, 0, $Script:PlayerMaxHitPoints)
        $Script:PlayerCurrentHitPoints = $t
        Test-GfmPlayerHpForState
        If($WriteToConsole) {
            Write-GfmPlayerHp
        }
    }
    
    End {
        If($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

#endregion

#region UPDATE-GFMPLAYERMP

<#
.SYNOPSIS
Updates the player's current magic points and writes it to the console window if applicable.

.PARAMETER MpDelta
The additive to the current magic points value. To subtract from the current magic points, assign this a negative value.

.PARAMETER WriteToConsole
Writes the MP String to the console at the predefined cell coordinates if necessary.
#>
Function Update-GfmPlayerMp {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$MpDelta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerCurrentMagicPoints + $MpDelta
        $t = [Math]::Clamp($t, 0, $Script:PlayerMaxMagicPoints)
        $Script:PlayerCurrentMagicPoints = $t
        Test-GfmPlayerMpForState
        If($WriteToConsole) {
            Write-GfmPlayerMp
        }
    }

    End {
        If($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

#endregion

#region UPDATE-GFMPLAYERGOLD

<#
.SYNOPSIS
Updates the player's current gold points and writes it to the console window if applicable.

.PARAMETER GDelta
The additive to the current gold points value. To subtract from the current gold points, assign this a negative value.

.PARAMETER WriteToConsole
Writes the Gold String to the console at the predefined cell coordinates if necessary.
#>
Function Update-GfmPlayerGold {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$GDelta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerCurrentGold + $GDelta
        $t = [Math]::Clamp($t, 0, $Script:PlayerMaxGold)
        $Script:PlayerCurrentGold = $t
        If($WriteToConsole) {
            Write-GfmPlayerGold
        }
    }

    End {
        If($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

#endregion

#region WRITE-GFMMESSAGEWINDOWMSG

<#
.SYNOPSIS
Writes a message to the Message Window Area

.PARAMETER Message
The message to add to the Message Window "queue".

.PARAMETER Teletype
Specifies if we're going to use the teletype method for printing the message to the window.
#>
Function Write-GfmMessageWindowMsg {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Message,
        [Parameter(Mandatory = $false)]
        [ConsoleColor]$ForegroundColor = 15,
        [Switch]$Teletype
    )

    Process {
        $Script:UiMessageWindowMsgAStr = $Script:UiMessageWindowMsgBStr; $Script:UiMessageWindowMsgAColor = $Script:UiMessageWindowMsgBColor
        $Script:UiMessageWindowMsgBStr = $Script:UiMessageWidnowMsgCStr; $Script:UiMessageWindowMsgBColor = $Script:UiMessageWindowMsgCColor
        $Script:UiMessageWindowMsgCStr = $Message; $Script:UiMessageWindowMsgCColor                       = $ForegroundColor
        
        If($Teletype) {
            Write-GfmPositionalString `
                -Coordinates $Script:UiMessageWindowMsgCDrawOrigin `
                -Message $Script:UiMessageWindowMsgBlank `
                -ForegroundColor 0
            Write-GfmPositionalTtyString `
                -Coordinates $Script:UiMessageWindowMsgCDrawOrigin `
                -Message $Script:UiMessageWindowMsgCStr `
                -ForegroundColor $Script:UiMessageWindowMsgCColor
            Write-GfmPositionalString `
                -Coordinates $Script:UiMessageWindowMsgBDrawOrigin `
                -Message $Script:UiMessageWindowMsgBlank `
                -ForegroundColor 0
            Write-GfmPositionalTtyString `
                -Coordinates $Script:UiMessageWindowMsgBDrawOrigin `
                -Message $Script:UiMessageWindowMsgBStr `
                -ForegroundColor $Script:UiMessageWindowMsgBColor
            Write-GfmPositionalString `
                -Coordinates $Script:UiMessageWindowMsgADrawOrigin `
                -Message $Script:UiMessageWindowMsgBlank `
                -ForegroundColor 0
            Write-GfmPositionalTtyString `
                -Coordinates $Script:UiMessageWindowMsgADrawOrigin `
                -Message $Script:UiMessageWindowMsgAStr `
                -ForegroundColor $Script:UiMessageWindowMsgAColor
        } Else {
            Write-GfmPositionalString `
                -Coordinates $Script:UiMessageWindowMsgCDrawOrigin `
                -Message $Script:UiMessageWindowMsgBlank `
                -ForegroundColor 0
            Write-GfmPositionalString `
                -Coordinates $Script:UiMessageWindowMsgCDrawOrigin `
                -Message $Script:UiMessageWindowMsgCStr `
                -ForegroundColor $Script:UiMessageWindowMsgCColor
            Write-GfmPositionalString `
                -Coordinates $Script:UiMessageWindowMsgBDrawOrigin `
                -Message $Script:UiMessageWindowMsgBlank `
                -ForegroundColor 0
            Write-GfmPositionalString `
                -Coordinates $Script:UiMessageWindowMsgBDrawOrigin `
                -Message $Script:UiMessageWindowMsgBStr `
                -ForegroundColor $Script:UiMessageWindowMsgBColor
            Write-GfmPositionalString `
                -Coordinates $Script:UiMessageWindowMsgADrawOrigin `
                -Message $Script:UiMessageWindowMsgBlank `
                -ForegroundColor 0
            Write-GfmPositionalString `
                -Coordinates $Script:UiMessageWindowMsgADrawOrigin `
                -Message $Script:UiMessageWindowMsgAStr `
                -ForegroundColor $Script:UiMessageWindowMsgAColor
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

#endregion

#region READ-GFMUSERCMDINPUT

<#
#>
Function Read-GfmUserCmdInput {
    [CmdletBinding()]
    Param ()

    Process {
        $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        While($keyCap.VirtualKeyCode -NE 13) {
            If($Script:Rui.CursorPosition.X -GE 19) {
                Invoke-GfmCmdParser
            }
            If($keyCap.VirtualKeyCode -EQ 8) {
                $fx = $Script:Rui.CursorPosition.X
                If($fx -GE $Script:DefaultCursorCoords.X) {
                    Write-GfmHostNnl `
                        -Message ' ' `
                        -ForegroundColor 0 `
                        -BackgroundColor 0
                    $Script:Rui.CursorPosition = [Coordinates]::new($fx - 1, $Script:DefaultCursorCoords.Y)
                    If($Script:UiCommandWindowCmdActual.Length -GT 0) {
                        $Script:UiCommandWindowCmdActual = $Script:UiCommandWindowCmdActual.Remove($Script:UiCommandWindowCmdActual.Length - 1, 1)
                    }
                } Else {
                    Write-GfmPositionalString `
                        -Coordinates $([Coordinates]::new($fx + 1, $Script:DefaultCursorCoords.Y)) `
                        -Message ' ' `
                        -ForegroundColor 0
                    Set-GfmDefaultCursorPosition
                    If($Script:UiCommandWindowCmdActual.Length -GT 0) {
                        $Script:UiCommandWindowCmdActual = $Script:UiCommandWindowCmdActual.Remove($Script:UiCommandWindowCmdActual.Length - 1, 1)
                    }
                }
            } Else {
                $Script:UiCommandWindowCmdActual += $keyCap.Character
            }

            $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        }

        Invoke-GfmCmdParser
    }
}

#endregion

#region INVOKE-GFMCMDPARSER

<#
#>
Function Invoke-GfmCmdParser {
    [CmdletBinding()]
    Param ()

    Process {
        Set-GfmDefaultCursorPosition
        Write-GfmHostNnl `
            -Message $Script:UiCommandWindowCmdBlank `
            -ForegroundColor 0
        If([String]::IsNullOrEmpty($Script:UiCommandWindowCmdActual)) {
            Return
        } Else {
            $cmdactSplit = -SPLIT $Script:UiCommandWindowCmdActual
            $rootFound   = $Script:CommandTable.GetEnumerator() | Where-Object { $_.Name -IEQ $cmdactSplit[0] }
            If($null -NE $rootFound) {
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

                    Default {}
                }
            } Else {
                Write-GfmBadCommandException
                Return
            }
        }
    }
}

#endregion

#region INVOKE-GFMITEMREACTOR

<#
#>
Function Invoke-GfmItemReactor {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$ItemName
    )

    Process {
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        If($a.Count -EQ 0) {
            Update-GfmCmdHistory -CmdActualValid
            Write-GfmMapNoItemsFoundException
            Return
        } Elseif($a.Count -GT 0) {
            Foreach($c in $a) {
                If($c.MapObjName -EQ $ItemName) {
                    Update-GfmCmdHistory -CmdActualValid
                    Invoke-Command $c.$Effect
                    Return
                }
            }
            Update-GfmCmdHistory -CmdActualValid
            Write-GfmMapInvalidItemException -ItemName $ItemName
            Return
        } Else {
            Write-GfmBadSomethingException
            Return
        }
    }
}

#endregion

#region INVOKE-GFMLOOKACTION

<##>
Function Invoke-GfmLookAction {
    [CmdletBinding()]
    Param ()

    Process {
        Update-GfmCmdHistory -CmdActualValid
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        $b = 78
        $c = ''
        $f = ''
        $z = 0
        $y = $false
        If($a.Count -LE 0) {
            Write-GfmMessageWindowMsg `
                -Message 'It doesn''t look like there''s anything of interest here.' `
                -ForegroundColor $Script:PlayerAsideColor `
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
        }$e = $c.Length
        If($e -GT $b) {
            $y = $true
            $c -MATCH '([\s,]+\w+){5}$' | Out-Null
            If($_ -EQ $true) {
                $c = $c -REPLACE '([\s,]+\w+){5}$', ''
                $f = $matches[0].Remove(0, 2)
            }
        }
        Write-GfmMessageWindowMsg `
            -Message 'I can see the following things here:' `
            -ForegroundColor $Script:PlayerAsideColor `
            -Teletype
        Write-GfmMessageWindowMsg `
            -Message $c `
            -ForegroundColor $Script:MapTileItemsDiscoveredColor `
            -Teletype
        If($y -EQ $true) {
            Write-GfmMessageWindowMsg `
                -Message $f `
                -ForegroundColor $Script:MapTileItemsDiscoveredColor `
                -Teletype
        }
    }
}

#endregion

#region INVOKE-GFMEXAMINEACTION

<##>
Function Invoke-GfmExamineAction {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$ItemName
    )

    Process {
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        Foreach($b in $a) {
            If($b.Name -EQ $ItemName) {
                Update-GfmCmdHistory -CmdActualValid
                Write-GfmMessageWindowMsg `
                    -Message $b.ExamineString `
                    -ForegroundColor $Script:PlayerAsideColor `
                    -Teletype
                Return
            }
        }
        Update-GfmCmdHistory
        Write-GfmMessageWindowMsg `
            -Message "There's no $ItemName to be found here..." `
            -ForegroundColor $Script:PlayerAsideColor `
            -Teletype
        Return
    }
}

#endregion

#region INVOKE-GFMGETACTION

<##>
Function Invoke-GfmGetAction {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$ItemName
    )

    Process {
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        If($a.Count -LE 0) {
            Update-GfmCmdHistory
            Write-GfmMessageWindowMsg `
                -Message 'There doesn''t appear to be anything to collect here...' `
                -ForegroundColor $Script:PlayerAsideColor `
                -Teletype
            Return
        }
        Foreach($b in $a) {
            If($b.Name -EQ $ItemName) {
                If($b.CanAddToInventory -EQ $true) {
                    $Script:PlayerInventory.Add($b) | Out-Null
                    $c = $a.Remove($b) | Out-Null
                    If($c -EQ $false) {
                        Write-Error 'Failed to remove item from Map Tile Object Listing!'
                        Exit
                    } Else {
                        Update-GfmCmdHistory -CmdActualValid
                        Write-GfmMessageWindowMsg `
                            -Message "I've taken the $($b.MapObjName) and put it in my pocket." `
                            -ForegroundColor $Script:PlayerAsideColor `
                            -Teletype
                        Return
                    }
                } Else {
                    Update-GfmCmdHistory
                    Write-GfmMessageWindowMsg `
                        -Message "It's not possible to take the $($b.MapObjName)." `
                        -ForegroundColor $Script:PlayerAsideColor `
                        -Teletype
                    Return
                }
            }
        }
        Update-GfmCmdHistory
        Write-GfmMessageWindowMsg `
            -Message "There's no $ItemName to be found here..." `
            -ForegroundColor $Script:PlayerAsideColor `
            -Teletype
        Return
    }
}

#endregion

#endregion