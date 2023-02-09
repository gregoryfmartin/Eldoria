using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

# GLOBAL VARIABLE DEFINITIONS

[String]       $Script:OsCheckLinux     = 'OsLinux'
[String]       $Script:OsCheckMac       = 'OsMac'
[String]       $Script:OsCheckWindows   = 'OsWindows'
[String]       $Script:OsCheckUnknown   = 'OsUnknown'
[Player]       $Script:ThePlayer        = [Player]::new('Steve', 500, 500, 25, 25, 5000, 5000)
[StatusWindow] $Script:TheStatusWindow  = [StatusWindow]::new()
[CommandWindow]$Script:TheCommandWindow = [CommandWindow]::new()

# ENUMERATION DEFINITIONS

Enum GameStatePrimary {
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

Enum GameStateSecondary {
    Normal
    Battle
    Shop
    Inn
}

Enum StatNumberState {
    Normal
    Caution
    Danger
}

# CLASS DEFINITIONS

<#
Defines a 24-bit color to be used in ANSI-based terminals. Each channel is clamped to appropriate unsigned integer values.
#>
Class ConsoleColor24 {
    [ValidateRange(0, 255)][Int]$Red
    [ValidateRange(0, 255)][Int]$Green
    [ValidateRange(0, 255)][Int]$Blue
    
    ConsoleColor24(
        [Int]$Red,
        [Int]$Green,
        [Int]$Blue
    ) {
        $this.Red   = $Red
        $this.Green = $Green
        $this.Blue  = $Blue
    }
}

Class ATControlSequences {
    Static [String]$ForegroundColor24Prefix = "`e[38;2;"
    Static [String]$BackgroundColor24Prefix = "`e[48;2;"
    Static [String]$DecorationBlink         = "`e[5m"
    Static [String]$ModifierReset           = "`e[0m"
    
    Static [String]GenerateFG24String([ConsoleColor24]$Color) {
        Return "$([ATControlSequences]::ForegroundColor24Prefix)$($Color.Red.ToString());$($Color.Green.ToString());$($Color.Blue.ToString())m"
    }
    
    Static [String]GenerateBG24String([ConsoleColor24]$Color) {
        Return "$([ATControlSequences]::BackgroundColor24Prefix)$($Color.Red.ToString());$($Color.Green.ToString());$($Color.Blue.ToString())m"
    }
    
    Static [String]GenerateCoordinateString([Int]$Row, [Int]$Column) {
        Return "`e[$($Row.ToString());$($Column.ToString())H"
    }
}

<#
Defines an ANSI Buffer Cell Foreground Color modifier in 24-bit color. This class leverages ConsoleColor24 to accomplish this.
#>
Class ATForegroundColor24 {
    [ValidateNotNullOrEmpty()][ConsoleColor24]$Color
    
    ATForegroundColor24(
        [ConsoleColor24]$Color
    ) {
        $this.Color = $Color
    }
    
    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateFG24String($this.Color)
    }
}

<#
Defines an ANSI Buffer Cell Background Color modifier in 24-bit color. This class leverages ConsoleColor24 to accomplish this.
#>
Class ATBackgroundColor24 {
    [ValidateNotNullOrEmpty()][ConsoleColor24]$Color
    
    ATBackgroundColor24(
        [ConsoleColor24]$Color
    ) {
        $this.Color = $Color
    }
    
    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateBG24String($this.Color)
    }
}

<#
Defines a collection of potential ANSI Buffer Cell decorators.
#>
Class ATDecoration {
    [ValidateNotNullOrEmpty()][Boolean]$Blink
    
    ATDecoration(
        [Boolean]$Blink
    ) {
        $this.Blink = $Blink
    }
    
    [String]ToAnsiControlSequenceString() {
        [String]$a = ""
        
        If($this.Blink) {
            $a += [ATControlSequences]::DecorationBlink
        }
        
        Return $a
    }
}

Class ATCoordinates {
    [ValidateNotNullOrEmpty()][Int]$Row
    [ValidateNotNullOrEmpty()][Int]$Column
    
    ATCoordinates(
        [Int]$Row,
        [Int]$Column
    ) {
        $this.Row = $Row
        $this.Column = $Column
    }
    
    ATCoordinates(
        [Coordinates]$AutomationCoordinates
    ) {
        $this.Row    = $AutomationCoordinates.X
        $this.Column = $AutomationCoordinates.Y
    }
    
    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateCoordinateString($this.Row, $this.Column)
    }

    [Coordinates]ToAutomationCoordinates() {
        Return [Coordinates]::new($this.Row, $this.Column)
    }
}

# Class ATReset {
#     [String]ToAnsiControlSequenceString() {
#         Return "`e[0m"
#     }
# }

Class CCBlack24 : ConsoleColor24 {
    CCBlack24() : base(0, 0, 0) {}
}

Class CCWhite24 : ConsoleColor24 {
    CCWhite24() : base(255, 255, 255) {}
}

Class CCRed24 : ConsoleColor24 {
    CCRed24() : base(255, 0, 0) {}
}

Class CCGreen24 : ConsoleColor24 {
    CCGreen24() : base(0, 255, 0) {}
}

Class CCBlue24 : ConsoleColor24 {
    CCBlue24() : base (0, 0, 255) {}
}

Class CCYellow24 : ConsoleColor24 {
    CCYellow24() : base(255, 255, 0) {}
}

Class CCDarkYellow24 : ConsoleColor24 {
    CCDarkYellow24() : base(255, 204, 0) {}
}

Class CCDarkCyan24 : ConsoleColor24 {
    CCDarkCyan24() : base(0, 139, 139) {}
}

Class CCDarkGrey24 : ConsoleColor24 {
    CCDarkGrey24() : base(45, 45, 45) {}
}

Class CCTextDefault24 : CCDarkGrey24 {}

Class ATForegroundColor24None : ATForegroundColor24 {
    ATForegroundColor24None(): base([CCBlack24]::new()) {}
    
    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATBackgroundColor24None : ATBackgroundColor24 {
    ATBackgroundColor24None() : base([CCBlack24]::new()) {}
    
    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATCoordinatesNone : ATCoordinates {
    ATCoordinatesNone(): base(0, 0) {}
    
    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATDecorationNone : ATDecoration {
    ATDecorationNone(): base($false) {}
    
    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATStringPrefix {
    [ValidateNotNullOrEmpty()][ATForegroundColor24]$ForegroundColor
    [ValidateNotNullOrEmpty()][ATBackgroundColor24]$BackgroundColor
    [ValidateNotNullOrEmpty()][ATDecoration]$Decorations
    [ValidateNotNullOrEmpty()][ATCoordinates]$Coordinates
    
    ATStringPrefix() {
        $this.ForegroundColor = [ATForegroundColor24None]::new()
        $this.BackgroundColor = [ATBackgroundColor24None]::new()
        $this.Decorations     = [ATDecorationNone]::new()
        $this.Coordinates     = [ATCoordinatesNone]::new()
    }
    
    ATStringPrefix(
        [ATForegroundColor24]$ForegroundColor,
        [ATBackgroundColor24]$BackgroundColor,
        [ATDecoration]$Decorations,
        [ATCoordinates]$Coordinates
    ) {
        $this.ForegroundColor = $ForegroundColor
        $this.BackgroundColor = $BackgroundColor
        $this.Decorations     = $Decorations
        $this.Coordinates     = $Coordinates
    }
    
    [String]ToAnsiControlSequenceString() {
        Return "$($this.Coordinates.ToAnsiControlSequenceString())$($this.Decorations.ToAnsiControlSequenceString())$($this.ForegroundColor.ToAnsiControlSequenceString())$($this.BackgroundColor.ToAnsiControlSequenceString())"
    }
}

Class ATStringPrefixNone : ATStringPrefix {
    ATStringPrefixNone() : base() {}
    
    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATString {
    [ValidateNotNullOrEmpty()][ATStringPrefix]$Prefix
    [ValidateNotNull()][String]$UserData
    [ValidateNotNullOrEmpty()][Boolean]$UseATReset
    
    ATString() {
        $this.Prefix     = [ATStringPrefixNone]::new()
        $this.UserData   = ''
        $this.UseATReset = $false
    }
    
    ATString(
        [ATStringPrefix]$Prefix,
        [String]$UserData,
        [Boolean]$UseATReset
    ) {
        $this.Prefix     = $Prefix
        $this.UserData   = $UserData
        $this.UseATReset = $UseATReset
    }
    
    [String]ToAnsiControlSequenceString() {
        [String]$a = "$($this.Prefix.ToAnsiControlSequenceString())$($this.UserData)"
        
        If($this.UseATReset) {
            $a += [ATControlSequences]::ModifierReset
        }
        
        Return $a
    }
}

Class ATStringNone : ATString {
    ATStringNone() : base() {}
    
    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class Player {
    [String]$Name
    [Int]$CurrentHitPoints
    [Int]$MaxHitPoints
    [Int]$CurrentMagicPoints
    [Int]$MaxMagicPoints
    [Int]$CurrentGold
    [Int]$MaxGold
    [StatNumberState]$HitPointsState
    [StatNumberState]$MagicPointsState
    [Coordinates]$MapCoordinates
    #[List[MapTileObject]]$Inventory
    
    Static [Single]$StatNumThresholdCaution         = 0.6D
    Static [Single]$StatNumThresholdDanger          = 0.2D
    Static [ConsoleColor24]$StatNameDrawColor       = [CCBlue24]::new()
    Static [ConsoleColor24]$StatNumDrawColorSafe    = [CCGreen24]::new()
    Static [ConsoleColor24]$StatNumDrawColorCaution = [CCYellow24]::new()
    Static [ConsoleColor24]$StatNumDrawColorDanger  = [CCRed24]::new()
    Static [ConsoleColor24]$StatGoldDrawColor       = [CCDarkYellow24]::new()
    Static [ConsoleColor24]$AsideDrawColor          = [CCDarkCyan24]::new()
    
    Player(
        [String]$Name,
        [Int]$CurrentHitPoints,
        [Int]$MaxHitPoints,
        [Int]$CurrentMagicPoints,
        [Int]$MaxMagicPoints,
        [Int]$CurrentGold,
        [Int]$MaxGold
    ) {
        $this.Name               = $Name
        $this.CurrentHitPoints   = $CurrentHitPoints
        $this.MaxHitPoints       = $MaxHitPoints
        $this.CurrentMagicPoints = $CurrentMagicPoints
        $this.MaxMagicPoints     = $MaxMagicPoints
        $this.CurrentGold        = $CurrentGold
        $this.MaxGold            = $MaxGold
        $this.HitPointsState     = [StatNumberState]::Normal
        $this.MagicPointsState   = [StatNumberState]::Normal
        $this.MapCoordinates     = [Coordinates]::new(0, 0)
    }
    
    [String]GetFormattedNameString([ATCoordinates]$Coordinates) {
        [ATString]$p1 = [ATString]::new(
            [ATStringPrefix]::new(
                [Player]::StatNameDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                $Coordinates
            ),
            $this.Name,
            $true
        )
        
        Return "$($p1.ToAnsiControlSequenceString())"
    }
    
    [String]GetFormattedHitPointsString([ATCoordinates]$Coordinates) {
        [String]$a = ''
        
        Switch($this.HitPointsState) {
            Normal {
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'H ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorSafe,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentHitPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorSafe,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxHitPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
            }
            
            Caution {
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'H ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorCaution,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentHitPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorCaution,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxHitPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
            }
            
            Danger {
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'H ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorDanger,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentHitPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorDanger,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxHitPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
            }
            
            Default {}
        }
        
        Return $a
    }
    
    [String]GetFormattedMagicPointsString([ATCoordinates]$Coordinates) {
        [String]$a = ''
        
        Switch($this.MagicPointsState) {
            Normal {
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'M ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorSafe,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentMagicPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorSafe,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxMagicPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
            }
            
            Caution {
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'M ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorCaution,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentMagicPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorCaution,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxMagicPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
            }
            
            Danger {
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'M ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorDanger,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentMagicPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorDanger,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxMagicPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
            }
            
            Default {}
        }
        
        Return $a
    }
    
    [String]GetFormattedGoldString([ATCoordinates]$Coordinates) {
        [ATString]$p1 = [ATString]::new(
            [ATStringPrefix]::new(
                [Player]::StatGoldDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                $Coordinates
            ),
            "$($this.CurrentGold)",
            $false
        )
        [ATString]$p2 = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            'G',
            $true
        )
        
        Return "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())"
    }
    
    [Void]TestCurrentHpState() {
        Switch($this.CurrentHitPoints) {
            { $_ -GT ($this.MaxHitPoints * [Player]::StatNumThresholdCaution) } {
                $this.HitPointsState = [StatNumberState]::Normal
            }
            
            { ($_ -GT ($this.MaxHitPoints * [Player]::StatNumThresholdDanger)) -AND ($_ -LT ($this.MaxHitPoints * [Player]::StatNumThresholdCaution)) } {
                $this.HitPointsState = [StatNumberState]::Caution
            }
            
            { $_ -LT ($this.MaxHitPoints * [Player]::StatNumThresholdDanger) } {
                $this.HitPointsState = [StatNumberState]::Danger
            }
            
            Default {}
        }
    }

    [Void]TestCurrentMpState() {
        Switch($this.CurrentMagicPoints) {
            { $_ -GT ($this.MaxMagicPoints * [Player]::StatNumThresholdCaution) } {
                $this.MagicPointsState = [StatNumberState]::Normal
            }
            
            { ($_ -GT ($this.MaxMagicPoints * [Player]::StatNumThresholdDanger)) -AND ($_ -LT ($this.MaxMagicPoints * [Player]::StatNumThresholdCaution)) } {
                $this.MagicPointsState = [StatNumberState]::Caution
            }
            
            { $_ -LT ($this.MaxMagicPoints * [Player]::StatNumThresholdDanger) } {
                $this.MagicPointsState = [StatNumberState]::Danger
            }
            
            Default {}
        }
    }
}

Class SceneImage {
    Static [Int]$Width                = 46
    Static [Int]$Height               = 18
    Static [ATCoordinates]$DrawOrigin = [ATCoordinates]::new(32, 1)
    
    [BufferCell[,]]$Image
    
    SceneImage() {
        $this.Image = New-Object 'BufferCell[,]' [SceneImage]::Height, [SceneImage]::Width
    }
    
    SceneImage(
        [BufferCell[,]]$Image
    ) {
        $this.Image = $Image
    }
}

Class WindowBase {
    Static [Int]$BorderDrawColorTop     = 0
    Static [Int]$BorderDrawColorBottom  = 1
    Static [Int]$BorderDrawColorLeft    = 2
    Static [Int]$BorderDrawColorRight   = 3
    Static [Int]$BorderStringHorizontal = 0
    Static [Int]$BorderStringVertical   = 1
    Static [Int]$BorderDirtyTop         = 0
    Static [Int]$BorderDirtyBottom      = 1
    Static [Int]$BorderDirtyLeft        = 2
    Static [Int]$BorderDirtyRight       = 3
    
    [ATCoordinates]$LeftTop
    [ATCoordinates]$RightBottom
    [ConsoleColor24[]]$BorderDrawColors
    [String[]]$BorderStrings
    [Boolean[]]$BorderDrawDirty
    [Int]$Width
    [Int]$Height

    WindowBase() {
        $this.LeftTop          = [ATCoordinatesNone]::new()
        $this.RightBottom      = [ATCoordinatesNone]::new()
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCBlack24]::new(),
            [CCBlack24]::new(),
            [CCBlack24]::new(),
            [CCBlack24]::new()
        )
        $this.BorderStrings = [String[]](
            '',
            ''
        )
        $this.BorderDrawDirty = [Boolean[]](
            $true,
            $true,
            $true,
            $true
        )
        $this.UpdateDimensions()
    }
    
    WindowBase(
        [ATCoordinates]$LeftTop,
        [ATCoordinates]$RightBottom,
        [ConsoleColor24[]]$BorderDrawColors,
        [String[]]$BorderStrings,
        [Boolean[]]$BorderDrawDirty
    ) {
        $this.LeftTop          = $LeftTop
        $this.RightBottom      = $RightBottom
        $this.BorderDrawColors = $BorderDrawColors
        $this.BorderStrings    = $BorderStrings
        $this.BorderDrawDirty  = $BorderDrawDirty
        $this.UpdateDimensions()
    }
    
    [Void]Draw() {
        Switch($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
                [ATString]$bt = [ATStringNone]::new()
                [ATString]$bb = [ATStringNone]::new()
                [ATString]$bl = [ATStringNone]::new()
                [ATString]$br = [ATStringNone]::new()
                
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyTop]) {
                    $bt = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorTop],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            $this.LeftTop
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyTop] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom]) {
                    $bb = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorBottom],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.RightBottom.Row, $this.LeftTop.Column)
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft]) {
                    $bl = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorLeft],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.LeftTop.Column)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''
                            
                            For($a = 0; $a -LE $this.Height - 3; $a++) {
                                If($a -NE $this.Height - 3) {
                                    $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical]) $([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.LeftTop.Column).ToAnsiControlSequenceString())"
                                } Else {
                                    $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])"
                                }
                            }
                            
                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyRight]) {
                    $br = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorRight],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.RightBottom.Column + 1)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''
                            
                            For($a = 0; $a -LE $this.Height - 3; $a++) {
                                If($a -NE $this.Height - 3) {
                                    $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical]) $([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, ($this.RightBottom.Column + 1)).ToAnsiControlSequenceString())"
                                } Else {
                                    $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])"
                                }
                            }
                            
                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyRight] = $false
                }

                
                Write-Host "$($bt.ToAnsiControlSequenceString())$($bb.ToAnsiControlSequenceString())$($bl.ToAnsiControlSequenceString())$($br.ToAnsiControlSequenceString())"
            }
            
            { $_ -EQ $Script:OsCheckWindows } {
                [ATString]$bt = [ATStringNone]::new()
                [ATString]$bb = [ATStringNone]::new()
                [ATString]$bl = [ATStringNone]::new()
                [ATString]$br = [ATStringNone]::new()
                
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyTop]) {
                    $bt = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorTop],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            $this.LeftTop
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyTop] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom]) {
                    $bb = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorBottom],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.RightBottom.Row, $this.LeftTop.Column)
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft]) {
                    $bl = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorLeft],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.LeftTop.Column)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.LeftTop.Column).ToAnsiControlSequenceString())"
                            }
                            
                            # For($a = 0; $a -LE $this.Height - 3; $a++) {
                            #     If($a -NE $this.Height - 3) {
                            #         $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical]) $([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.LeftTop.Column).ToAnsiControlSequenceString())"
                            #     } Else {
                            #         $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])"
                            #     }
                            # }
                            
                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyRight]) {
                    $br = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorRight],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.RightBottom.Column + 1)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.RightBottom.Column + 1).ToAnsiControlSequenceString())"
                            }
                            
                            # For($a = 0; $a -LE $this.Height - 3; $a++) {
                            #     If($a -NE $this.Height - 3) {
                            #         $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical]) $([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, ($this.RightBottom.Column + 1)).ToAnsiControlSequenceString())"
                            #     } Else {
                            #         $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])"
                            #     }
                            # }
                            
                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyRight] = $false
                }

                
                Write-Host "$($bt.ToAnsiControlSequenceString())$($bb.ToAnsiControlSequenceString())$($bl.ToAnsiControlSequenceString())$($br.ToAnsiControlSequenceString())"
            }
            
            Default {}
        }
    }

    [Void]UpdateDimensions() {
        # $this.Width  = $this.LeftTop.Column + $this.RightBottom.Column
        # $this.Height = $this.LeftTop.Row + $this.RightBottom.Row
        $this.Width  = $this.RightBottom.Column - $this.LeftTop.Column
        $this.Height = $this.RightBottom.Row - $this.LeftTop.Row
    }
}

Class StatusWindow : WindowBase {
    Static [ATCoordinates]$PlayerNameDrawCoordinates = [ATCoordinates]::new(2, 3)
    Static [ATCoordinates]$PlayerHpDrawCoordinates   = [ATCoordinates]::new(4, 3)
    Static [ATCoordinates]$PlayerMpDrawCoordinates   = [ATCoordinates]::new(6, 3)
    Static [ATCoordinates]$PlayerGoldDrawCoordinates = [ATCoordinates]::new(9, 3)
    # Static [ATCoordinates]$PlayerAilDrawCoordinates  = [ATCoordinates]::new(2, 11)
    
    [Boolean]$PlayerNameDrawDirty
    [Boolean]$PlayerHpDrawDirty
    [Boolean]$PlayerMpDrawDirty
    [Boolean]$PlayerGoldDrawDirty
    # [Boolean]$PlayerAilDrawDirty
    
    StatusWindow() : base() {
        $this.LeftTop          = [ATCoordinates]::new(1, 1)
        $this.RightBottom      = [ATCoordinates]::new(10, 19)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            '@--~---~---~---~---@',
            '|'
        )
        $this.UpdateDimensions()
        $this.PlayerNameDrawDirty = $true
        $this.PlayerHpDrawDirty   = $true
        $this.PlayerMpDrawDirty   = $true
        $this.PlayerGoldDrawDirty = $true
        # $this.PlayerAilDrawDirty  = $true
    }
    
    [Void]Draw() {
        ([WindowBase]$this).Draw()
        
        Switch($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {}
            
            { $_ -EQ $Script:OsCheckWindows } {
                If($this.PlayerNameDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedNameString([StatusWindow]::PlayerNameDrawCoordinates)
                    $this.PlayerNameDrawDirty = $false
                }
                If($this.PlayerHpDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedHitPointsString([StatusWindow]::PlayerHpDrawCoordinates)
                    $this.PlayerHpDrawDirty = $false
                }
                If($this.PlayerMpDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedMagicPointsString([StatusWindow]::PlayerMpDrawCoordinates)
                    $this.PlayerMpDrawDirty = $false
                }
                If($this.PlayerGoldDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedGoldString([StatusWindow]::PlayerGoldDrawCoordinates)
                    $this.PlayerGoldDrawDirty = $false
                }
            }
            
            Default {}
        }
    }
}

Class CommandWindow : WindowBase {
    Static [Int]$CommandHistoryARef = 0
    Static [Int]$CommandHistoryBRef = 1
    Static [Int]$CommandHistoryCRef = 2
    Static [Int]$CommandHistoryDRef = 3

    Static [ATCoordinates]$CommandDivDrawCoordinates      = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryDDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryCDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryBDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryADrawCoordinates = [ATCoordinatesNone]::new()

    Static [ConsoleColor24]$HistoryEntryValid = [CCGreen24]::new()
    Static [ConsoleColor24]$HistoryEntryError = [CCRed24]::new()
    Static [ConsoleColor24]$HistoryBlankColor = [CCBlack24]::new()
    Static [ATString]$CommandDiv              = [ATStringNone]::new()
    Static [ATString]$CommandBlank            = [ATStringNone]::new()

    [ATString]$CommandActual
    [ATString[]]$CommandHistory

    CommandWindow() : base() {
        $this.LeftTop          = [ATCoordinates]::new(12, 1)
        $this.RightBottom      = [ATCoordinates]::new(20, 19)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            '@--~---~---~---~---@',
            '|'
        )
        $this.UpdateDimensions()

        [Int]$rowBase    = $this.Height
        [Int]$columnBase = $this.LeftTop.Column + 1

        [CommandWindow]::CommandDivDrawCoordinates      = [ATCoordinates]::new($rowBase - 2, $columnBase)
        [CommandWindow]::CommandHistoryDDrawCoordinates = [ATCoordinates]::new($rowBase - 3, $columnBase)
        [CommandWindow]::CommandHistoryCDrawCoordinates = [ATCoordinates]::new($rowBase - 4, $columnBase)
        [CommandWindow]::CommandHistoryBDrawCoordinates = [ATCoordinates]::new($rowBase - 5, $columnBase)
        [CommandWindow]::CommandHistoryADrawCoordinates = [ATCoordinates]::new($rowBase - 6, $columnBase)

        $this.CommandActual                                       = [ATStringNone]::new()
        $this.CommandHistory                                      = New-Object 'ATString[]' 4
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef] = [ATStringNone]::new()
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef] = [ATStringNone]::new()
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef] = [ATStringNone]::new()
        $this.CommandHistory[[CommandWindow]::CommandHistoryDRef] = [ATStringNone]::new()
        
        [CommandWindow]::CommandDiv = [ATString]::new(
            [ATStringPrefix]::new(
                [CCWhite24]::new(), # I should add a custom color for the div
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandDivDrawCoordinates
            ),
            '``````````````````',
            $true
        )
        # [CommandWindow]::CommandBlank = [ATString]::new(
        #     [ATStringPrefix]::new(
        #         [CommandWindow]::HistoryBlankColor,
        #         [ATBackgroundColor24None]::new(),
        #         [ATDecoration]::new(),
        #         [ATCoordinatesNone]::new() # These can't yet be specified
        #     ),
        #     '                  ',
        #     $true
        # )
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()
    }
}

# FUNCTION DEFINITIONS

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

# RUNNER
Clear-Host

$Script:TheStatusWindow.Draw()
$Script:TheCommandWindow.Draw()

Read-Host
