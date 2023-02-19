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
[SceneWindow]  $Script:TheSceneWindow   = [SceneWindow]::new()
[MessageWindow]$Script:TheMessageWindow = [MessageWindow]::new()
[SceneImage]   $Script:SampleSi         = [SceneImage]::new($null)
[SIRandomNoise]$Script:SampleSiRandom   = [SIRandomNoise]::new()

$Script:TheSceneWindow.Image = [SIFieldNorthRoad]::new()
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

    ConsoleColor24(
        [PSCustomObject]$JsonData
    ) {
        $psoProps = $JsonData.PSObject.Properties
        $this.Red   = [Int]$psoProps['Red'].Value
        $this.Green = [Int]$psoProps['Green'].Value
        $this.Blue  = [Int]$psoProps['Blue'].Value
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

    ATForegroundColor24(
        [PSCustomObject]$JsonData
    ) {
        $this.Color = [ConsoleColor24]::new($JsonData)
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

    ATBackgroundColor24(
        [PSObject]$JsonData
    ) {
        $this.Color = [ConsoleColor24]::new($JsonData)
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

    ATDecoration(
        [PSObject]$JsonData
    ) {
        $psoProps = $JsonData.PSObject.Properties
        $this.Blink = [Boolean]$psoProps['Blink'].Value
    }
    
    [String]ToAnsiControlSequenceString() {
        [String]$a = ''
        
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
        $this.Row    = $Row
        $this.Column = $Column
    }
    
    ATCoordinates(
        [Coordinates]$AutomationCoordinates
    ) {
        $this.Row    = $AutomationCoordinates.X
        $this.Column = $AutomationCoordinates.Y
    }

    ATCoordinates(
        [PSObject]$JsonData
    ) {
        $psoProps    = $JsonData.PSObject.Properties
        $this.Row    = [Int]$psoProps['Row'].Value
        $this.Column = [Int]$psoProps['Column'].Value
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

Class CCRandom24 : ConsoleColor24 {
    CCRandom24() : base($(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0)) {}
}

# https://www.pantone.com/connect/14-4318-TCX
Class CCPantoneSkyBlue24 : ConsoleColor24 {
    CCPantoneSkyBlue24(): base(54, 73, 83) {}
}

# https://www.pantone.com/connect/15-6322-TPX
Class CCPantoneLightGrassGreen24 : ConsoleColor24 {
    CCPantoneLightGrassGreen24(): base(49, 70, 53) {}
}

# https://www.pantone.com/connect/19-1218-TCX
Class CCPantonePottingSoil24 : ConsoleColor24 {
    CCPantonePottingSoil24(): base(33, 22, 18) {}
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

Class ATCoordinatesDefault : ATCoordinates {
    ATCoordinatesDefault() : base(0, 0) {} # TODO: Need to set these values relative to the Command Window
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

Class ATSceneImageString : ATString {
    Static [String]$SceneImageBlank = ' '

    ATSceneImageString(
        [ATBackgroundColor24]$BackgroundColor,
        [ATCoordinates]$Coordinates
    ): base() {
        $this.Prefix = [ATStringPrefix]::new(
            [ATForegroundColor24None]::new(),
            $BackgroundColor,
            [ATDecorationNone]::new(),
            $Coordinates
        )
        $this.UserData   = [ATSceneImageString]::SceneImageBlank
        $this.UseATReset = $true
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
    Static [Int]$Width  = 48
    Static [Int]$Height = 18
    
    [ATSceneImageString[,]]$Image
    
    SceneImage() {
        $this.Image = New-Object 'ATSceneImageString[,]' ([Int32]([SceneImage]::Height)), ([Int32]([SceneImage]::Width))
    }
    
    SceneImage(
        [ATSceneImageString[,]]$Image
    ) {
        $this.Image = $Image
    }

    [Void]CreateSceneImageATString([ATBackgroundColor24[]]$ImageColorMap) {
        For($r = 0; $r -LT [SceneImage]::Height; $r++) {
            For($c = 0; $c -LT [SceneImage]::Width; $c++) {
                $rf = ($r * [SceneImage]::Width) + $c
                $this.Image[$r, $c] = [ATSceneImageString]::new(
                    $ImageColorMap[$rf],
                    [ATCoordinates]::new(([SceneWindow]::ImageDrawRowOffset + $r), ([SceneWindow]::ImageDrawColumnOffset + $c))
                )
            }
        }
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        For($r = 0; $r -LT [SceneImage]::Height; $r++) {
            For($c = 0; $c -LT [SceneImage]::Width; $c++) {
                $a += $this.Image[$r, $c].ToAnsiControlSequenceString()
            }
        }

        Return $a
    }
}

Class SIEmpty : SceneImage {
    SIEmpty(): base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class SIInternalBase : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIInternalBase(): base() {
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))
    }
}

Class SIRandomNoise : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIRandomNoise(): base() {
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))

        For($a = 0; $a -LT $this.ColorMap.Count; $a++) {
            $this.ColorMap[$a] = [CCRandom24]::new()
        }

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldNorthRoad : SIInternalBase {
    SIFieldNorthRoad(): base() {
        $this.ColorMap[0]   = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[1]   = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[2]   = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[3]   = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[4]   = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[5]   = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[6]   = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[7]   = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[8]   = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[9]   = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[10]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[11]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[12]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[13]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[14]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[15]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[16]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[17]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[18]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[19]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[20]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[21]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[22]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[23]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[24]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[25]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[26]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[27]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[28]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[29]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[30]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[31]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[32]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[33]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[34]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[35]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[36]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[37]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[38]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[39]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[40]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[41]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[42]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[43]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[44]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[45]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[46]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[47]  = [CCPantoneSkyBlue24]::new() # End Row 0
        $this.ColorMap[48]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[49]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[50]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[51]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[52]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[53]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[54]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[55]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[56]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[57]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[58]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[59]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[60]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[61]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[62]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[63]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[64]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[65]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[66]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[67]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[68]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[69]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[70]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[71]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[72]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[73]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[74]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[75]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[76]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[77]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[78]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[79]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[80]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[81]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[82]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[83]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[84]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[85]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[86]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[87]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[88]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[89]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[90]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[91]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[92]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[93]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[94]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[95]  = [CCPantoneSkyBlue24]::new() # End Row 1
        $this.ColorMap[96]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[97]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[98]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[99]  = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[100] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[101] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[102] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[103] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[104] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[105] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[106] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[107] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[108] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[109] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[110] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[111] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[112] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[113] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[114] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[115] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[116] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[117] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[118] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[119] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[120] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[121] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[122] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[123] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[124] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[125] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[126] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[127] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[128] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[129] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[130] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[131] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[132] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[133] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[134] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[135] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[136] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[137] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[138] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[139] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[140] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[141] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[143] = [CCPantoneSkyBlue24]::new() # End Row 2
        $this.ColorMap[144] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[145] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[146] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[147] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[148] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[149] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[150] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[151] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[152] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[153] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[154] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[155] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[156] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[157] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[158] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[159] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[160] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[161] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[162] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[163] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[164] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[165] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[166] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[167] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[168] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[169] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[170] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[171] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[172] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[173] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[174] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[175] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[176] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[177] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[178] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[179] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[180] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[181] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[182] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[183] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[184] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[185] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[186] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[187] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[188] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[189] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[190] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[191] = [CCPantoneSkyBlue24]::new() # End Row 3
        $this.ColorMap[192] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[193] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[194] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[195] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[196] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[197] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[198] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[199] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[200] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[201] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[202] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[203] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[204] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[205] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[206] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[207] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[208] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[209] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[210] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[211] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[212] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[213] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[214] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[215] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[216] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[217] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[218] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[219] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[220] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[221] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[222] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[223] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[224] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[225] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[226] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[227] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[228] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[229] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[230] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[231] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[232] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[233] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[234] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[235] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[236] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[237] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[238] = [CCPantoneSkyBlue24]::new()
        $this.ColorMap[239] = [CCPantoneSkyBlue24]::new() # End Row 4
        $this.ColorMap[240] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[241] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[242] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[243] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[244] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[245] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[246] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[247] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[248] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[249] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[250] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[251] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[252] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[253] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[254] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[255] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[256] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[257] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[258] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[259] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[260] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[261] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[262] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[263] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[264] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[265] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[266] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[267] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[268] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[269] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[270] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[271] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[272] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[273] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[274] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[275] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[276] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[277] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[278] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[279] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[280] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[281] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[282] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[283] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[284] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[285] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[286] = [CCPantoneLightGrassGreen24]::new()
        $this.ColorMap[287] = [CCPantoneLightGrassGreen24]::new() # End Row 5

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
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

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.LeftTop.Column).ToAnsiControlSequenceString())"
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

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.RightBottom.Column + 1).ToAnsiControlSequenceString())"
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
    Static [Int]$PlayerStatDrawColumn = 3
    Static [Int]$PlayerNameDrawRow    = 2
    Static [Int]$PlayerHpDrawRow      = 4
    Static [Int]$PlayerMpDrawRow      = 6
    Static [Int]$PlayerGoldDrawRow    = 9
    Static [Int]$WindowLTRow          = 1
    Static [Int]$WindowLTColumn       = 1
    Static [Int]$WindowRBRow          = 10
    Static [Int]$WindowRBColumn       = 19

    Static [String]$WindowBorderHorizontal = '@--~---~---~---~---@'
    Static [String]$WindowBorderVertical   = '|'

    Static [ATCoordinates]$PlayerNameDrawCoordinates = [ATCoordinates]::new([StatusWindow]::PlayerNameDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerHpDrawCoordinates   = [ATCoordinates]::new([StatusWindow]::PlayerHpDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerMpDrawCoordinates   = [ATCoordinates]::new([StatusWindow]::PlayerMpDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerGoldDrawCoordinates = [ATCoordinates]::new([StatusWindow]::PlayerGoldDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    # Static [ATCoordinates]$PlayerAilDrawCoordinates  = [ATCoordinates]::new(2, 11)
    
    [Boolean]$PlayerNameDrawDirty
    [Boolean]$PlayerHpDrawDirty
    [Boolean]$PlayerMpDrawDirty
    [Boolean]$PlayerGoldDrawDirty
    # [Boolean]$PlayerAilDrawDirty
    
    StatusWindow() : base() {
        $this.LeftTop          = [ATCoordinates]::new([StatusWindow]::WindowLTRow, [StatusWindow]::WindowLTColumn)
        $this.RightBottom      = [ATCoordinates]::new([StatusWindow]::WindowRBRow, [StatusWindow]::WindowRBColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [StatusWindow]::WindowBorderHorizontal,
            [StatusWindow]::WindowBorderVertical
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
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
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
    Static [Int]$CommandHistoryARef    = 0
    Static [Int]$CommandHistoryBRef    = 1
    Static [Int]$CommandHistoryCRef    = 2
    Static [Int]$CommandHistoryDRef    = 3
    Static [Int]$WindowLTRow           = 12
    Static [Int]$WindowLTColumn        = 1
    Static [Int]$WindowRBRow           = 20
    Static [Int]$WindowRBColumn        = 19
    Static [Int]$DrawColumnOffset      = 1
    Static [Int]$DrawDivRowOffset      = 2
    Static [Int]$DrawHistoryDRowOffset = 3
    Static [Int]$DrawHistoryCRowOffset = 4
    Static [Int]$DrawHistoryBRowOffset = 5
    Static [Int]$DrawHistoryARowOffset = 6

    Static [String]$WindowBorderHorizontal = '@--~---~---~---~---@'
    Static [String]$WindowBorderVertical   = '|'
    Static [String]$WindowCommandDiv       = '``````````````````'

    Static [ATCoordinates]$CommandDivDrawCoordinates      = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryDDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryCDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryBDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryADrawCoordinates = [ATCoordinatesNone]::new()

    Static [ConsoleColor24]$HistoryEntryValid   = [CCGreen24]::new()
    Static [ConsoleColor24]$HistoryEntryError   = [CCRed24]::new()
    Static [ConsoleColor24]$HistoryBlankColor   = [CCBlack24]::new()
    Static [ConsoleColor24]$CommandDivDrawColor = [CCWhite24]::new()
    Static [ATString]$CommandDiv                = [ATStringNone]::new()
    Static [ATString]$CommandBlank              = [ATStringNone]::new()

    [ATString]$CommandActual
    [ATString[]]$CommandHistory

    [Boolean]$CommandDivDirty

    CommandWindow() : base() {
        $this.LeftTop          = [ATCoordinates]::new([CommandWindow]::WindowLTRow, [CommandWindow]::WindowLTColumn)
        $this.RightBottom      = [ATCoordinates]::new([CommandWindow]::WindowRBRow, [CommandWindow]::WindowRBColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [CommandWindow]::WindowBorderHorizontal,
            [CommandWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()

        $this.CommandDivDirty = $true

        [Int]$rowBase    = $this.RightBottom.Row
        [Int]$columnBase = $this.LeftTop.Column + [CommandWindow]::DrawColumnOffset

        [CommandWindow]::CommandDivDrawCoordinates      = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawDivRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryDDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryDRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryCDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryCRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryBDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryBRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryADrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryARowOffset, $columnBase)

        $this.CommandActual                                       = [ATStringNone]::new()
        $this.CommandHistory                                      = New-Object 'ATString[]' 4 # This literal can't be codified; PS requires it be here
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef] = [ATStringNone]::new()
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef] = [ATStringNone]::new()
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef] = [ATStringNone]::new()
        $this.CommandHistory[[CommandWindow]::CommandHistoryDRef] = [ATStringNone]::new()
        
        [CommandWindow]::CommandDiv = [ATString]::new(
            [ATStringPrefix]::new(
                [CommandWindow]::CommandDivDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandDivDrawCoordinates
            ),
            [CommandWindow]::WindowCommandDiv,
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

        If($this.CommandDivDirty) {
            Write-Host "$([CommandWindow]::CommandDiv.ToAnsiControlSequenceString())"
            $this.CommandDivDirty = $false
        }
    }
}

Class SceneWindow : WindowBase {
    Static [Int]$WindowLTRow           = 1
    Static [Int]$WindowLTColumn        = 30
    Static [Int]$WindowRBRow           = 20
    Static [Int]$WindowRBColumn        = 78
    Static [Int]$ImageDrawRowOffset    = [SceneWindow]::WindowLTRow + 1
    Static [Int]$ImageDrawColumnOffset = [SceneWindow]::WindowLTColumn + 1
    

    Static [String]$WindowBorderHorizontal = '@-<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>-@'
    Static [String]$WindowBorderVertical   = '|'

    Static [ATCoordinates]$SceneImageDrawCoordinates = [ATCoordinatesNone]::new()

    [Boolean]$SceneImageDirty = $true
    [SceneImage]$Image        = [SIEmpty]::new()

    SceneWindow(): base() {
        $this.LeftTop          = [ATCoordinates]::new([SceneWindow]::WindowLTRow, [SceneWindow]::WindowLTColumn)
        $this.RightBottom      = [ATCoordinates]::new([SceneWindow]::WindowRBRow, [SceneWindow]::WindowRBColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [SceneWindow]::WindowBorderHorizontal,
            [SceneWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()

        #[SceneWindow]::SceneImageDrawCoordinates = [ATCoordinates]::new($this.LeftTop.Row + [SceneWindow]::ImageDrawRowOffset, $this.LeftTop.Column + [SceneWindow]::ImageDrawColumnOffset)
        [SceneWindow]::SceneImageDrawCoordinates = [ATCoordinates]::new([SceneWindow]::ImageDrawRowOffset, [SceneWindow]::ImageDrawColumnOffset)
    }
    
    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.SceneImageDirty) {
            Write-Host "$($this.Image.ToAnsiControlSequenceString())"
            $this.SceneImageDirty = $false
        }
    }
}

Class MessageWindow : WindowBase {
    Static [Int]$WindowLTRow    = 21
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowBRRow    = 26
    Static [Int]$WindowBRColumn = 80
    
    Static [String]$WindowBorderHorizontal = '-------------------------------------------------------------------------------'
    Static [String]$WindowBorderVertical   = '|'
    
    MessageWindow() : base() {
        $this.LeftTop          = [ATCoordinates]::new(21, 1)
        $this.RightBottom      = [ATCoordinates]::new(25, 78)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [MessageWindow]::WindowBorderHorizontal,
            [MessageWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions() 
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
$Script:TheSceneWindow.Draw()
$Script:TheMessageWindow.Draw()
#$Script:SampleSi.Serialize() | Out-File './SampleOutput.txt'

Read-Host
