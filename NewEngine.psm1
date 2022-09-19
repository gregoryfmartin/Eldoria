#region Global Variables

#region Game State Definitions

[Flags()] Enum GlobalGameState {
    SplashScreenA
    SplashScreenB
    TitleScreen
    PlayerSetupScreen
    GamePlayScreen
    Cleanup
}

[Flags()] Enum GamePlayState {
    Normal
    Battle
    Shop
    Inn
}

#endregion

#region Player-Specific Variables

[Flags()] Enum PlayerHpState {
    Normal
    Caution
    Danger
}

[Flags()] Enum PlayerMpState {
    Normal
    Caution
    Danger
}

[String]             $Script:PlayerName                       = ''
[Int]                $Script:PlayerCurrentHitPoints           = 0
[Int]                $Script:PlayerMaximumHitPoints           = 0
[Int]                $Script:PlayerCurrentMagicPoints         = 0
[Int]                $Script:PlayerMaximumMagicPoints         = 0
[Int]                $Script:PlayerCurrentGold                = 0
[Single]             $Script:PlayerStatNumThresholdCaution    = 0.6D
[Single]             $Script:PlayerStatNumThresholdDanger     = 0.2D
[PlayerHpState]      $Script:PlayerHitPointsState             = [PlayerHpState]::Normal
[PlayerMpState]      $Script:PlayerMagicPointsState           = [PlayerMpState]::Normal
[System.ConsoleColor]$Script:PlayerStatNameDrawColor          = 'Blue'
[System.ConsoleColor]$Script:PlayerStatNumberDrawColorSafe    = 'Green'
[System.ConsoleColor]$Script:PlayerStatNumberDrawColorCaution = 'Yellow'
[System.ConsoleColor]$Script:PlayerStatNumberDrawColorDanger  = 'Red'
[System.ConsoleColor]$Script:PlayerStatGoldDrawColor          = 'DarkYellow'

#endregion

#region Scene Image Variables

[Int]$Script:SceneImageWidth       = 46
[Int]$Script:SceneImageHeight      = 18
[Int]$Script:SceneImageDrawOriginX = 32
[Int]$Script:SceneImageDrawOriginY = 1

#endregion

#region Status Window Variables

[System.ConsoleColor]$Script:UiStatusWindowBorderColor      = 'White'
[String]             $Script:UiStatusWindowBorderHoirzontal = '@--~---~---~---~---@'
[String]             $Script:UiStatusWindowBorderVertical   = '|'
[Int]                $Script:UiStatusWindowDrawX            = 0
[Int]                $Script:UiStatusWindowDrawY            = 0
[Int]                $Script:UiStatusWindowWidth            = 19
[Int]                $Script:UiStatusWindowHeight           = 14
[Int]                $Script:UiStatusWindowPlayerNameDrawX  = 2
[Int]                $Script:UiStatusWindowPlayerNameDrawY  = 2
[Int]                $Script:UiStatusWindowPlayerHpDrawX    = 2
[Int]                $Script:UiStatusWindowPlayerHpDrawY    = 4
[Int]                $Script:UiStatusWindowPlayerMpDrawX    = 2
[Int]                $Script:UiStatusWindowPlayerMpDrawY    = 6
[Int]                $Script:UiStatusWindowPlayerGoldDrawX  = 2
[Int]                $Script:UiStatusWindowPlayerGoldDrawY  = 9
[Int]                $Script:UiStatusWindowPlayerAilDrawX   = 2
[Int]                $Script:UiStatusWindowPlayerAilDrawY   = 11

#endregion

#region Scene Window Variables

[System.ConsoleColor]$Script:UiSceneWindowBorderColor      = 'White'
[String]             $Script:UiSceneWindowBorderHorizontal = '@-<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>-@'
[String]             $Script:UiSceneWindowBorderVertical   = '|'
[Int]                $Script:UiSceneWindowDrawX            = 30
[Int]                $Script:UiSceneWindowDrawY            = 0
[Int]                $Script:UiSceneWindowWidth            = 50
[Int]                $Script:UiSceneWindowHeight           = 19
[Int]                $Script:UiSceneWindowSceneDrawX       = 32
[Int]                $Script:UiSceneWindowSceneDrawY       = 1

#endregion

#region Message Window Variables

[System.ConsoleColor]$Script:UiMessageWindowBorderColor      = 'White'
[String]             $Script:UiMessageWindowBorderHorizontal = '-'
[String]             $Script:UiMessageWindowBorderVertical   = '|'
[Int]                $Script:UiMessageWindowDrawX            = 0
[Int]                $Script:UiMessageWindowDrawY            = 20
[Int]                $Script:UiMessageWindowWidth            = 80
[Int]                $Script:UiMessageWindowHeight           = 4

#endregion

#region General Globals

$Script:Rui = $(Get-Host).UI.RawUI

[Int]   $Script:DefaultCursorX = 0
[Int]   $Script:DefaultCursorY = 0
[String]$Script:OsCheckLinux   = 'OsLinux'
[String]$Script:OsCheckMac     = 'OsMac'
[String]$Script:OsCheckWindows = 'OsWindows'
[String]$Script:OsCheckUnknown = 'OsUnknown'

#endregion

#region Scene Image Definitions

$Script:SceneImageSample = New-Object 'System.Management.Automation.Host.BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth

#endregion

#region Text Rendering Variables

[Flags()] Enum TtySpeed {
    SuperSlow = 1000000
    Slow      = 750000
    Normal    = 100000
    Moderate  = 75000
    Quick     = 65000
    Fast      = 50000
    SuperFast = 25000
}

#endregion

#endregion

#region Text Formatting Functions

Function Format-GfmPlayerHitPoints {
    [CmdletBinding()]
    Param ()
    
    Process {
        Return "H $($Script:PlayerCurrentHitPoints) `n`t/ $($Script:PlayerMaximumHitPoints)"
    }
}

Function Format-GfmPlayerMagicPoints {
    [CmdletBinding()]
    Param ()
    
    Process {
        Return "M $($Script:PlayerCurrentMagicPoints) `n`t/ $($Script:PlayerMaximumMagicPoints)"
    }
}

Function Format-GfmPlayerGold {
    [CmdletBinding()]
    Param ()

    Process {
        Return "$($Script:PlayerCurrentGold)G"
    }
}

#endregion

#region Scene Image Functions

Function New-GfmSceneImageSample {
    [CmdletBinding()]
    Param ()

    Process {
        For($h = 0; $h -LT $Script:SceneImageHeight; $h++) {
            For($w = 0; $w -LT $Script:SceneImageWidth; $w++) {
                [Int]$randBgColor = Get-Random -Minimum 1 -Maximum 15
                $Script:SceneImageSample[$h, $w] = [System.Management.Automation.Host.BufferCell]::new(' ', 0, $randBgColor, 'Complete')
            }
        }
    }
}

Function Write-GfmSceneImage {
    [CmdletBinding()]
    Param (
        [Switch]$NonWindowsMethod,
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.Host.BufferCell[,]]$CellArray
    )

    Process {
        If ($NonWindowsMethod) {
            For($h = 0; $h -LT $Script:SceneImageHeight; $h++) {
                For($w = 0; $w -LT $Script:SceneImageWidth; $w++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:SceneImageDrawOriginX + $w, $Script:SceneImageDrawOriginY + $h)
                    Write-Host ' ' -BackgroundColor $CellArray[$h, $w].BackgroundColor -NoNewline
                }
            }
        } Else {
            # This is what I've been trying to accomplish on the Mac and Linux and it doesn't work on those two platforms.
            # This actually appears to be faster too
            $Script:Rui.SetBufferContents($([System.Management.Automation.Host.Coordinates]::new($Script:SceneImageDrawOriginX, $Script:SceneImageDrawOriginY)), $CellArray)
        }
    }
}

#endregion

#region Utility Functions

Function Test-GfmOs {
    [CmdletBinding()]
    Param ()

    Process {
        Get-PSDrive -Name Variable | Out-Null
        If($?) {
            Get-ChildItem Variable:/IsLinux | Out-Null
            If($?) {
                If($(Get-ChildItem Variable:/IsLinux).Value -EQ $true) {
                    Return $Script:OsCheckLinux
                }
            }

            Get-ChildItem Variable:/IsMacOS | Out-Null
            If($?) {
                If($(Get-ChildItem Variable:/IsMacOS).Value -EQ $true) {
                    Return $Script:OsCheckMac
                }
            }

            Get-ChildItem Variable:/IsWindows | Out-Null
            If($?) {
                If($(Get-ChildItem Variable:/IsWindows).Value -EQ $true) {
                    Return $Script:OsCheckWindows
                }
            }
        }

        Return $Script:OsCheckUnknown
    }
}

Function Write-GfmHostNnl {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [System.ConsoleColor]$ForegroundColor,
        [Parameter(Mandatory = $false)]
        [System.ConsoleColor]$BackgroundColor = 'Black'
    )

    Process {
        Write-Host $Message -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    }
}

Function Set-GfmDefaultCursorPosition {
    [CmdletBinding()]
    Param ()

    Process {
        $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:DefaultCursorX, $Script:DefaultCursorY)
    }
}

Function Write-GfmPositionalString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.Host.Coordinates]$Coordinates,
        [Parameter(Mandatory = $true)]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [System.ConsoleColor]$ForegroundColor
    )

    Process {
        $Script:Rui.CursorPosition = $Coordinates
        Write-GfmHostNnl -Message $Message -ForegroundColor $ForegroundColor
    }
}

Function Write-GfmTtyString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [System.ConsoleColor]$ForegroundColor,
        [Parameter(Mandatory = $false)]
        [TtySpeed]$TypeSpeed = [TtySpeed]::Normal
    )

    Process {
        [Char[]]$msgCharArray = $Message.ToCharArray()
        [Int]   $typeCounter  = 0
        [Int]   $msgcaProbe   = 0

        While ($msgcaProbe -LE ($msgCharArray.Count - 1)) {
            $typeCounter++
            If($typeCounter -GE $TypeSpeed) {
                $typeCounter = 0
                Write-GfmHostNnl -Message $msgCharArray[$msgcaProbe] -ForegroundColor $ForegroundColor
                $msgcaProbe++
            }
        }
    }
}

Function Write-GfmPositionalTtyString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.Host.Coordinates]$Coordinates,
        [Parameter(Mandatory = $true)]
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

Function Write-GfmPlayerName {
    [CmdletBinding()]
    Param ()

    Process {
        Write-GfmPositionalString `
            -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerNameDrawX, $Script:UiStatusWindowPlayerNameDrawY)) `
            -Message $Script:PlayerName `
            -ForegroundColor $Script:PlayerStatNameDrawColor
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

Function Write-GfmPlayerHp {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($Script:PlayerHitPointsState) {
            # The fix for properly strong-typing the scoping is found here: https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-switch?view=powershell-7.2#enum
            ([PlayerHpState]::Normal) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorSafe
            }

            ([PlayerHpState]::Caution) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorCaution
            }

            ([PlayerHpState]::Danger) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }

            Default {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

Function Write-GfmPlayerMp {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($Script:PlayerMagicPointsState) {
            # The fix for properly strong-typing the scoping is found here: https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-switch?view=powershell-7.2#enum
            ([PlayerMpState]::Normal) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorSafe
            }

            ([PlayerMpState]::Caution) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorCaution
            }

            ([PlayerMpState]::Danger) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }

            Default {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

Function Write-GfmPlayerGold {
    [CmdletBinding()]
    Param ()

    Process {
        Write-GfmPositionalString `
            -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerGoldDrawX, $Script:UiStatusWindowPlayerGoldDrawY)) `
            -Message $(Format-GfmPlayerGold) `
            -ForegroundColor $Script:PlayerStatGoldDrawColor
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

Function Test-GfmPlayerHpForState {
    [CmdletBinding()]
    Param ()

    Process {
        If ($Script:PlayerCurrentHitPoints -GT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdCaution)) {
            $Script:PlayerHitPointsState = [PlayerHpState]::Normal
        } Elseif (($Script:PlayerCurrentHitPoints -GT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdDanger)) -AND ($Script:PlayerCurrentHitPoints -LT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdCaution))) {
            $Script:PlayerHitPointsState = [PlayerHpState]::Caution
        } Elseif ($Script:PlayerCurrentHitPoints -LT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdDanger)) {
            $Script:PlayerHitPointsState = [PlayerHpState]::Danger
        }
    }
}

Function Test-GfmPlayerMpForState {
    [CmdletBinding()]
    Param ()

    Process {
        If ($Script:PlayerCurrentMagicPoints -GT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdCaution)) {
            $Script:PlayerMagicPointsState = [PlayerMpState]::Normal
        } Elseif (($Script:PlayerCurrentMagicPoints -GT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdDanger)) -AND ($Script:PlayerCurrentMagicPoints -LT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdCaution))) {
            $Script:PlayerMagicPointsState = [PlayerMpState]::Caution
        } Elseif ($Script:PlayerCurrentMagicPoints -LT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdDanger)) {
            $Script:PlayerMagicPointsState = [PlayerMpState]::Danger
        }
    }
}

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

Function Update-GfmPlayerHp {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$HpDelta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerCurrentHitPoints + $HpDelta
        $t = [System.Math]::Clamp($t, 0, $Script:PlayerMaximumHitPoints)
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

Function Update-GfmPlayerMp {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$MpDelta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerCurrentMagicPoints + $MpDelta
        $t = [System.Math]::Clamp($t, 0, $Script:PlayerMaximumMagicPoints)
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

Function Update-GfmPlayerGold {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$GDelta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerCurrentGold + $GDelta
        $t = [System.Math]::Clamp($t, 0, [Int]::MaxValue)
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

#region Window Drawing Functions

Function Write-GfmStatusWindow {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($(Test-GfmOs)) {
            {($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac)} {
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY + $Script:UiStatusWindowHeight)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                For($i = 1; $i -LT $Script:UiStatusWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiStatusWindowDrawX + $Script:UiStatusWindowWidth), $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                # For the time being, I'm simply going to copypaste the code from the previous case
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY + $Script:UiStatusWindowHeight)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                For($i = 1; $i -LT $Script:UiStatusWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiStatusWindowDrawX + $Script:UiStatusWindowWidth), $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
                }
            }

            Default {}
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

Function Write-GfmSceneWindow {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($(Test-GfmOs)) {
            {($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac)} {
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, $Script:UiSceneWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, $Script:UiSceneWindowDrawY + $Script:UiSceneWindowWidth)
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                For($i = 1; $i -LT $Script:UiSceneWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiSceneWindowDrawX + $Script:UiSceneWindowWidth), $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, $Script:UiSceneWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, ($Script:UiSceneWindowDrawY + $Script:UiSceneWindowHeight))
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                For($i = 1; $i -LT $Script:UiSceneWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiSceneWindowDrawX + $Script:UiSceneWindowWidth) - 1, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
                }
            }

            Default {}
        }
    }

    End {}
}

Function Write-GfmMessageWindow {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($(Test-GfmOs)) {
            {($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac)} {
                For($i = 0; $i -LT $Script:UiMessageWindowWidth; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($i, $Script:UiMessageWindowDrawY)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($i, ($Script:UiMessageWindowDrawY + $Script:UiMessageWindowHeight))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                }
                For($i = 0; $i -LE $Script:UiMessageWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiMessageWindowDrawX, ($Script:UiMessageWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiMessageWindowDrawX + $Script:UiMessageWindowWidth), ($Script:UiMessageWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                For($i = 0; $i -LE $Script:UiMessageWindowWidth - 1; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($i, $Script:UiMessageWindowDrawY)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($i, ($Script:UiMessageWindowDrawY + $Script:UiMessageWindowHeight))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                }
                For($i = 0; $i -LT $Script:UiMessageWindowHeight - 1; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiMessageWindowDrawX, ($Script:UiMessageWindowDrawY + $i) + 1)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiMessageWindowDrawX + $Script:UiMessageWindowWidth) - 1, ($Script:UiMessageWindowDrawY + $i) + 1)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
                }
            }

            Default {}
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

#endregion

#region Testing Functions

Function Test-GfmPlayScreen {
    [CmdletBinding()]
    Param ()

    Process {
        New-GfmSceneImageSample
        Write-GfmSceneImage -CellArray $Script:SceneImageSample

        $Script:PlayerName               = 'Steve'
        $Script:PlayerCurrentHitPoints   = 100
        $Script:PlayerMaximumHitPoints   = 100
        $Script:PlayerCurrentMagicPoints = 25
        $Script:PlayerMaximumMagicPoints = 25
        $Script:PlayerCurrentGold        = 5000

        Write-GfmPlayerName
        Write-GfmPlayerHp
        Write-GfmPlayerMp
        Write-GfmPlayerGold
    }
}

#endregion