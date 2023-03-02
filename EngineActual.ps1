using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

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

# ANSI CONTROL SEQUENCE DEFINITIONS
[String]$Script:ACSForegroundColor24Prefix = "`e[38;2;"
[String]$Script:ACSBackgroundColor24Prefix = "`e[48;2;"
[String]$Script:ACSDecorationBlink         = "`e[5m"
[String]$Script:ACSModifierReset           = "`e[0m"
[String]$Script:ACSForegroundColor24None   = ''
[String]$Script:ACSBackgroundColor24None   = ''
[String]$Script:ACSDecorationNone          = ''
[String]$Script:ACSCoordsNone              = ''
[String]$Script:ACSPrefixNone              = ''
[String]$Script:ACSequenceNone             = ''

# ANSI CONTROL SEQUENCE GENERATOR FUNCTIONS
Function Script:Format-ACSColor24SuffixString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 255)]
        [Int]$Red,
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 255)]
        [Int]$Green,
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 255)]
        [Int]$Blue
    )

    Process {
        Return "$($Red.ToString());$($Green.ToString());$($Blue.ToString())m"
    }
}

Function Script:Format-ACSForegroundColor24String {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ACSColorSuffix
    )

    Process {
        Return "$($ACSForegroundColor24Prefix)$($ACSColorSuffix)"
    }
}

Function Script:Format-ACSBackgroundColor24String {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ACSColorSuffix
    )

    Process {
        Return "$($ACSBackgroundColor24Prefix)$($ACSColorSuffix)"
    }
}

Function Script:Format-ACSCursorCoordinateString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$Row,
        [Parameter(Mandatory = $true)]
        [Int]$Column
    )

    Process {
        Return "`e[$($Row.ToString());$($Column.ToString())H"
    }
}

Function Script:Format-ACSPrefix {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]$ACSForegroundColor,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]$ACSBackgroundColor,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]$ACSDecoration,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]$ACSCoordinates
    )

    Process {
        Return "$($ACSForegroundColor)$($ACSBackgroundColor)$($ACSDecoration)$($ACSCoordinates)"
    }
}

Function Script:Format-ACSequence {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]$ACSPrefix,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]$TextData,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Boolean]$UseACSReset
    )

    Process {
        [String]$a = "$($ACSPrefix)$($TextData)"

        If($UseACSReset) {
            $a += "$($ACSModifierReset)"
        }

        Return $a
    }
}

Function Script:Format-ACSSceneImageString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]$ACSForegroundColor,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]$ACSCoordinates
    )

    Process {
        Return "$($ACSCoordinates)$($ACSForegroundColor)"
    }
}

# ANSI PREDEFINED COLOR DEFINITIONS
# REQUIRED TO BE HERE SINCE THESE CALL FUNCTIONS FOR THEIR VALUES
[String]$Script:ACSColorBlack                  = "$(Script:Format-ACSColor24SuffixString -Red 0 -Green 0 -Blue 0)"
[String]$Script:ACSColorWhite                  = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 255 -Blue 255)"
[String]$Script:ACSColorRed                    = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 0 -Blue 0)"
[String]$Script:ACSColorGreen                  = "$(Script:Format-ACSColor24SuffixString -Red 0 -Green 255 -Blue 0)"
[String]$Script:ACSColorBlue                   = "$(Script:Format-ACSColor24SuffixString -Red 0 -Green 0 -Blue 255)"
[String]$Script:ACSColorYellow                 = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 255 -Blue 0)"
[String]$Script:ACSColorDarkYellow             = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 204 -Blue 0)"
[String]$Script:ACSColorDarkCyan               = "$(Script:Format-ACSColor24SuffixString -Red 0 -Green 139 -Blue 139)"
[String]$Script:ACSColorDarkGrey               = "$(Script:Format-ACSColor24SuffixString -Red 45 -Green 45 -Blue 45)"
[String]$Script:ACSColorRandom                 = "$(Script:Format-ACSColor24SuffixString -Red $(Get-Random -Maximum 255 -Minimum 0) -Green $(Get-Random -Maximum 255 -Minimum 0) -Blue $(Get-Random -Maximum 255 -Minimum 0))"
[String]$Script:ACSColorAppleRedLight          = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 59 -Blue 48)"
[String]$Script:ACSColorAppleRedDark           = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 69 -Blue 58)"
[String]$Script:ACSColorAppleOrangeLight       = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 149 -Blue 0)"
[String]$Script:ACSColorAppleOrangeDark        = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 159 -Blue 0)"
[String]$Script:ACSColorAppleYellowLight       = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 204 -Blue 0)"
[String]$Script:ACSColorAppleYellowDark        = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 214 -Blue 10)"
[String]$Script:ACSColorAppleGreenLight        = "$(Script:Format-ACSColor24SuffixString -Red 52 -Green 199 -Blue 89)"
[String]$Script:ACSColorAppleGreenDark         = "$(Script:Format-ACSColor24SuffixString -Red 48 -Green 209 -Blue 88)"
[String]$Script:ACSColorAppleMintLight         = "$(Script:Format-ACSColor24SuffixString -Red 0 -Green 199 -Blue 190)"
[String]$Script:ACSColorAppleMintDark          = "$(Script:Format-ACSColor24SuffixString -Red 99 -Green 230 -Blue 226)"
[String]$Script:ACSColorAppleTealLight         = "$(Script:Format-ACSColor24SuffixString -Red 48 -Green 176 -Blue 199)"
[String]$Script:ACSColorAppleTealDark          = "$(Script:Format-ACSColor24SuffixString -Red 64 -Green 200 -Blue 224)"
[String]$Script:ACSColorAppleCyanLight         = "$(Script:Format-ACSColor24SuffixString -Red 50 -Green 173 -Blue 230)"
[String]$Script:ACSColorAppleCyanDark          = "$(Script:Format-ACSColor24SuffixString -Red 100 -Green 210 -Blue 255)"
[String]$Script:ACSColorAppleBlueLight         = "$(Script:Format-ACSColor24SuffixString -Red 0 -Green 122 -Blue 255)"
[String]$Script:ACSColorAppleBlueDark          = "$(Script:Format-ACSColor24SuffixString -Red 10 -Green 132 -Blue 255)"
[String]$Script:ACSColorAppleIndigoLight       = "$(Script:Format-ACSColor24SuffixString -Red 88 -Green 86 -Blue 214)"
[String]$Script:ACSColorAppleIndigoDark        = "$(Script:Format-ACSColor24SuffixString -Red 94 -Green 92 -Blue 230)"
[String]$Script:ACSColorApplePurpleLight       = "$(Script:Format-ACSColor24SuffixString -Red 175 -Green 82 -Blue 222)"
[String]$Script:ACSColorApplePurpleDark        = "$(Script:Format-ACSColor24SuffixString -Red 191 -Green 90 -Blue 242)"
[String]$Script:ACSColorApplePinkLight         = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 45 -Blue 85)"
[String]$Script:ACSColorApplePinkDark          = "$(Script:Format-ACSColor24SuffixString -Red 255 -Green 55 -Blue 95)"
[String]$Script:ACSColorAppleBrownLight        = "$(Script:Format-ACSColor24SuffixString -Red 162 -Green 132 -Blue 94)"
[String]$Script:ACSColorAppleBrownDark         = "$(Script:Format-ACSColor24SuffixString -Red 172 -Green 142 -Blue 104)"
[String]$Script:ACSColorAppleGrey1Light        = "$(Script:Format-ACSColor24SuffixString -Red 142 -Green 142 -Blue 147)"
[String]$Script:ACSColorAppleGrey1Dark         = "$(Script:Format-ACSColor24SuffixString -Red 142 -Green 142 -Blue 147)"
[String]$Script:ACSColorAppleGrey2Light        = "$(Script:Format-ACSColor24SuffixString -Red 174 -Green 174 -Blue 178)"
[String]$Script:ACSColorAppleGrey2Dark         = "$(Script:Format-ACSColor24SuffixString -Red 99 -Green 99 -Blue 102)"
[String]$Script:ACSColorAppleGrey3Light        = "$(Script:Format-ACSColor24SuffixString -Red 199 -Green 199 -Blue 204)"
[String]$Script:ACSColorAppleGrey3Dark         = "$(Script:Format-ACSColor24SuffixString -Red 72 -Green 72 -Blue 74)"
[String]$Script:ACSColorAppleGrey4Light        = "$(Script:Format-ACSColor24SuffixString -Red 209 -Green 209 -Blue 214)"
[String]$Script:ACSColorAppleGrey4Dark         = "$(Script:Format-ACSColor24SuffixString -Red 58 -Green 58 -Blue 60)"
[String]$Script:ACSColorAppleGrey5Light        = "$(Script:Format-ACSColor24SuffixString -Red 229 -Green 229 -Blue 234)"
[String]$Script:ACSColorAppleGrey5Dark         = "$(Script:Format-ACSColor24SuffixString -Red 44 -Green 44 -Blue 46)"
[String]$Script:ACSColorAppleGrey6Light        = "$(Script:Format-ACSColor24SuffixString -Red 242 -Green 242 -Blue 247)"
[String]$Script:ACSColorAppleGrey6Dark         = "$(Script:Format-ACSColor24SuffixString -Red 28 -Green 28 -Blue 30)"
[String]$Script:ACSColorPantoneSkyBlue         = "$(Script:Format-ACSColor24SuffixString -Red 54 -Green 73 -Blue 83)"
[String]$Script:ACSColorPantoneLightGrassGreen = "$(Script:Format-ACSColor24SuffixString -Red 49 -Green 70 -Blue 53)"
[String]$Script:ACSColorPantonePottingSoil     = "$(Script:Format-ACSColor24SuffixString -Red 33 -Green 22 -Blue 18)"
[String]$Script:ACSColorTextDefault            = $Script:ACSColorAppleGrey3Dark

# ANSI PREDEFINED COORDINATE DEFINITIONS
[String]$Script:ACSCoordsDefault = "$(Script:Format-ACSCursorCoordinateString -Row 0 -Column 0)"

# PLAYER PREDEFINED VARIABLES
[String]$Script:PlayerName                    = 'Steve'
[Int]$Script:PlayerCurrentHitPoints           = 0
[Int]$Script:PlayerMaximumHitPoints           = 0
[Int]$Script:PlayerCurrentMagicPoints         = 0
[Int]$Script:PlayerMaximumMagicPoints         = 0
[Int]$Script:PlayerCurrentGold                = 0
[Int]$Script:PlayerMaximumGold                = 0
[Int]$Script:PlayerMapCoordinateRow           = 0
[Int]$Script:PlayerMapCoordinateColumn        = 0
[Int]$Script:PlayerHitPointsState             = 0 # 0 = Normal, 1 = Caution, 2 = Danger
[Int]$Script:PlayerMagicPointsState           = 0 # 0 = Normal, 1 = Caution, 2 = Danger
[Single]$Script:PlayerStatNumThresholdCaution = 0.6D
[Single]$Script:PlayerStatNumThresholdDanger  = 0.2D
[String]$Script:PlayerStatNameDrawColor       = $ACSColorAppleBlueLight
[String]$Script:PlayerStatDrawColorSafe       = $ACSColorAppleGreenLight
[String]$Script:PlayerStatDrawColorCaution    = $ACSColorAppleYellowLight
[String]$Script:PlayerStatDrawColorDanger     = $ACSColorAppleRedLight
[String]$Script:PlayerStatDrawColorGold       = $ACSColorAppleYellowDark
[String]$Script:PlayerStatDrawColorAside      = $ACSColorAppleIndigoLight

Function Script:Format-PlayerNameString {
    [CmdletBinding()]
    Param ()

    Process {
        Return "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorAppleBlueLight)$($Script:PlayerName)$($Script:ACSModifierReset)"
    }
}

Function Script:Format-PlayerHitPointsString {
    [CmdletBinding()]
    Param ()

    Process {
        [String]$a = "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorTextDefault)H "

        Switch($Script:PlayerHitPointsState) {
            0 {
                $a += "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorSafe)$($Script:PlayerCurrentHitPoints) `n`t$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorTextDefault)/ $(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorSafe)$($Script:PlayerMaximumHitPoints)$($Script:ACSModifierReset)"
            }

            1 {
                $a += "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorCaution)$($Script:PlayerCurrentHitPoints) `n`t$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorTextDefault)/ $(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorCaution)$($Script:PlayerMaximumHitPoints)$($Script:ACSModifierReset)"
            }

            2 {
                $a += "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorDanger)$($Script:PlayerCurrentHitPoints) `n`t$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorTextDefault)/ $(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorDanger)$($Script:PlayerMaximumHitPoints)$($Script:ACSModifierReset)"
            }

            Default {
                $a += "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorSafe)$($Script:PlayerCurrentHitPoints) `n`t$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorTextDefault)/ $(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorSafe)$($Script:PlayerMaximumHitPoints)$($Script:ACSModifierReset)"
            }
        }

        Return $a
    }
}

Function Script:Format-PlayerMagicPointsString {
    [CmdletBinding()]
    Param ()

    Process {
        [String]$a = "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorTextDefault)M "

        Switch($Script:PlayerMagicPointsState) {
            0 {
                $a += "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorSafe)$($Script:PlayerCurrentMagicPoints) `n`t$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorTextDefault)/ $(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorSafe)$($Script:PlayerMaximumMagicPoints)$($Script:ACSModifierReset)"
            }

            1 {
                $a += "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorCaution)$($Script:PlayerCurrentMagicPoints) `n`t$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorTextDefault)/ $(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorCaution)$($Script:PlayerMaximumMagicPoints)$($Script:ACSModifierReset)"
            }

            2 {
                $a += "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorDanger)$($Script:PlayerCurrentMagicPoints) `n`t$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorTextDefault)/ $(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorDanger)$($Script:PlayerMaximumMagicPoints)$($Script:ACSModifierReset)"
            }

            Default {
                $a += "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorSafe)$($Script:PlayerCurrentMagicPoints) `n`t$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorTextDefault)/ $(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorSafe)$($Script:PlayerMaximumMagicPoints)$($Script:ACSModifierReset)"
            }
        }

        Return $a
    }
}

Function Script:Format-PlayerGoldString {
    [CmdletBinding()]
    Param ()

    Process {
        Return "$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:PlayerStatDrawColorGold)$($Script:PlayerCurrentGold)$(Script:Format-ACSForegroundColor24String -ACSColorSuffix $Script:ACSColorTextDefault)G$($Script:ACSModifierReset)"
    }
}

Function Script:Test-PlayerHitPointsState {
    [CmdletBinding()]
    Param ()

    Process {
        Switch($Script:PlayerCurrentHitPoints) {
            { $_ -GT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdCaution) } {
                $Script:PlayerHitPointsState = 0 # Normal
            }

            { ($_ -GT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdDanger)) -AND ($_ -LT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdCaution)) } {
                $Script:PlayerHitPointsState = 1 # Caution
            }

            { $_ -LT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdDanger) } {
                $Script:PlayerHitPointsState = 2 # Danger
            }

            Default {
                # This shouldn't get here, but default to safe bcuz
                $Script:PlayerHitPointsState = 0
            }
        }
    }
}

Function Script:Test-PlayerMagicPointsState {
    [CmdletBinding()]
    Param ()

    Process {
        Switch($Script:PlayerCurrentMagicPoints) {
            { $_ -GT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdCaution) } {
                $Script:PlayerMagicPointsState = 0 # Normal
            }

            { ($_ -GT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdDanger)) -AND ($_ -LT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdCaution)) } {
                $Script:PlayerMagicPointsState = 1 # Caution
            }

            { $_ -LT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdDanger) } {
                $Script:PlayerMagicPointsState = 2 # Danger
            }

            Default {
                # This shouldn't get here, but default to safe bcuz
                $Script:PlayerMagicPointsState = 0
            }
        }
    }
}

# SCENE IMAGE VARIABLES
[Int]$Script:SceneImageColumns = 48
[Int]$Script:SceneImageRows    = 18

Function Script:Format-SceneImage {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [String[]]$ColorMap
    )

    Process {
        [String]$a = ''

        If($PSBoundParameters.ContainsKey('ColorMap')) {
            For($r = 0; $r -LT $Script:SceneImageRows; $r++) {
                For($c = 0; $c -LT $Script:SceneImageColumns; $c++) {
                    $rf = ($r * $Script:SceneImageColumns) + $c
                    $a += "$(Script:Format-ACSCursorCoordinateString -Row ($Script:SIDrawRowOffset + $r) -Column ($Script:SIDrawColOffset + $c))$(Script:Format-ACSBackgroundColor24String -ACSColorSuffix $ColorMap[$rf]) $($Script:ACSModifierReset)"
                }
            }
        } Else {
            # Generate random colors
            For($r = 0; $r -LT $Script:SceneImageRows; $r++) {
                For($c = 0; $c -LT $Script:SceneImageColumns; $c++) {
                    $rf = ($r * $Script:SceneImageColumns) + $c
                    $a += "$(Script:Format-ACSCursorCoordinateString -Row ($Script:SIDrawRowOffset + $r) -Column ($Script:SIDrawColOffset + $c))$(Script:Format-ACSBackgroundColor24String -ACSColorSuffix $Script:ACSColorRandom) $($Script:ACSModifierReset)"
                }
            }
        }

        Return $a
    }
}
