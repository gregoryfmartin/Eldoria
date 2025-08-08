using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# PLAYER STATUS SUMMARY WINDOW
#
# THIS WINDOW DISPLAYS THE PLAYER'S CURRENT STATUS INCLUDING:
# - PROFILE IMAGE
# - NAME/GENDER/AFFINITY
# - CURRENT STATS
# - EQUIPPED ITEMS
#
###############################################################################

Class PlayerStatusSummaryWindow : WindowBase {
    Static [Int]$WindowLTRow            = 1
    Static [Int]$WindowLTColumn         = 13
    Static [Int]$WindowRBRow            = 16
    Static [Int]$WindowRBColumn         = 68
    Static [Int]$ColStatDrawOffset      = 26
    Static [Int]$ColEquipDrawOffset     = 36
    Static [Int]$ColEquipNameDrawOffset = 2

    Static [String]$WindowTitle   = 'Summary'
    Static [String]$EmptySlotText = 'Empty'

    [ATStringComposite]$PlayerNameAndGenderActual
    [ATStringComposite]$PlayerStatsActual
    [ATStringComposite]$PlayerEquipActual

    [Boolean]$PlayerInfoDirty

    PlayerStatusSummaryWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [PlayerStatusSummaryWindow]::WindowLTRow
            Column = [PlayerStatusSummaryWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [PlayerStatusSummaryWindow]::WindowRBRow
            Column = [PlayerStatusSummaryWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()
        $this.SetupTitle([PlayerStatusSummaryWindow]::WindowTitle, [CCTextDefault24]::new())

        $this.PlayerInfoDirty = $true

        $this.SetupPlayerNameAndGenderActual()
        $this.SetupPlayerStatsActual()
        $this.SetupPlayerEquipActual()
    }

    [Void]SetupPlayerNameAndGenderActual() {
        $this.PlayerNameAndGenderActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 1
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColStatDrawOffset
                    }
                }
                UserData   = "$($Script:ThePlayer.Name) "
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Male) {
                        Return 'M'
                    } Else {
                        Return 'F'
                    }
                })
                UseATReset = $true
            }
        ))
    }

    [Void]SetupPlayerStatsActual() {
        $this.PlayerStatsActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.Affinity].Item2
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColStatDrawOffset
                    }
                }
                UserData = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.Affinity].Item1) "
            },
            [ATString]@{
                UserData = (Invoke-Command -ScriptBlock {
                    Switch($Script:ThePlayer.Affinity) {
                        ([BattleActionType]::ElementalFire) { Return 'Fire' }

                        ([BattleActionType]::ElementalWater) { Return 'Water' }

                        ([BattleActionType]::ElementalEarth) { Return 'Earth' }

                        ([BattleActionType]::ElementalWind) { Return 'Wind' }

                        ([BattleActionType]::ElementalLight) { Return 'Light' }

                        ([BattleActionType]::ElementalDark) { Return 'Dark' }

                        ([BattleActionType]::ElementalIce) { Return 'Ice' }

                        Default { Return 'None' }
                    }
                })
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColStatDrawOffset
                    }
                }
                UserData = 'ATK: '
            },
            [ATString]@{
                UserData = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Attack].Base
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColStatDrawOffset
                    }
                }
                UserData = 'DEF: '
            },
            [ATString]@{
                UserData = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Defense].Base
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 7
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColStatDrawOffset
                    }
                }
                UserData = 'MAT: '
            },
            [ATString]@{
                UserData = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::MagicAttack].Base
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 8
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColStatDrawOffset
                    }
                }
                UserData = 'MDF: '
            },
            [ATString]@{
                UserData = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::MagicDefense].Base
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 9
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColStatDrawOffset
                    }
                }
                UserData = 'SPD: '
            },
            [ATString]@{
                UserData = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Speed].Base
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 10
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColStatDrawOffset
                    }
                }
                UserData = 'LCK: '
            },
            [ATString]@{
                UserData = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Luck].Base
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 11
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColStatDrawOffset
                    }
                }
                UserData = 'ACC: '
            },
            [ATString]@{
                UserData = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Accuracy].Base
            }
        ))
    }

    [Void]SetupPlayerEquipActual() {
        $this.PlayerEquipActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset
                    }
                }
                UserData   = "$($Script:IconWeapon)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 5
                        Column = ($this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset) + [PlayerStatusSummaryWindow]::ColEquipNameDrawOffset
                    }
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($null -EQ $Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Weapon]) {
                        Return ' None'
                    } Else {
                        Return " $($Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Weapon].Name)"
                    }
                })
                UseATReset = $true
            }
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset
                    }
                }
                UserData = "$($Script:IconHelmet)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = ($this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset) + [PlayerStatusSummaryWindow]::ColEquipNameDrawOffset
                    }
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($null -EQ $Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Helmet]) {
                        Return ' None'
                    } Else {
                        Return " $($Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Weapon].Name)"
                    }
                })
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 7
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset
                    }
                }
                UserData = "$($Script:IconArmor)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 7
                        Column = ($this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset) + [PlayerStatusSummaryWindow]::ColEquipNameDrawOffset
                    }
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($null -EQ $Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Armor]) {
                        Return ' None'
                    } Else {
                        Return " $($Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Armor].Name)"
                    }
                })
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 8
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset
                    }
                }
                UserData = "$($Script:IconPauldron)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 8
                        Column = ($this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset) + [PlayerStatusSummaryWindow]::ColEquipNameDrawOffset
                    }
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($null -EQ $Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Pauldron]) {
                        Return ' None'
                    } Else {
                        Return " $($Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Pauldron].Name)"
                    }
                })
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 9
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset
                    }
                }
                UserData = "$($Script:IconGauntlet)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 9
                        Column = ($this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset) + [PlayerStatusSummaryWindow]::ColEquipNameDrawOffset
                    }
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($null -EQ $Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Gauntlets]) {
                        Return ' None'
                    } Else {
                        Return " $($Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Gauntlets].Name)"
                    }
                })
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 10
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset
                    }
                }
                UserData = "$($Script:IconGreave)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 10
                        Column = ($this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset) + [PlayerStatusSummaryWindow]::ColEquipNameDrawOffset
                    }
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($null -EQ $Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Greaves]) {
                        Return ' None'
                    } Else {
                        Return " $($Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Greaves].Name)"
                    }
                })
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 11
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset
                    }
                }
                UserData = "$($Script:IconBoot)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 11
                        Column = ($this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset) + [PlayerStatusSummaryWindow]::ColEquipNameDrawOffset
                    }
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($null -EQ $Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Boots]) {
                        Return ' None'
                    } Else {
                        Return " $($Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Boots].Name)"
                    }
                })
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 12
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset
                    }
                }
                UserData = "$($Script:IconJewelry)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 12
                        Column = ($this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset) + [PlayerStatusSummaryWindow]::ColEquipNameDrawOffset
                    }
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($null -EQ $Script:ThePlayer.EquipmentListing[[EquipmentSlot]::JewelryA]) {
                        Return ' None'
                    } Else {
                        Return " $($Script:ThePlayer.EquipmentListing[[EquipmentSlot]::JewelryA].Name)"
                    }
                })
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 13
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset
                    }
                }
                UserData = "$($Script:IconJewelry)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 13
                        Column = ($this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset) + [PlayerStatusSummaryWindow]::ColEquipNameDrawOffset
                    }
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($null -EQ $Script:ThePlayer.EquipmentListing[[EquipmentSlot]::JewelryB]) {
                        Return ' None'
                    } Else {
                        Return " $($Script:ThePlayer.EquipmentListing[[EquipmentSlot]::JewelryB].Name)"
                    }
                })
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 14
                        Column = $this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset
                    }
                }
                UserData = "$($Script:IconCape)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 14
                        Column = ($this.LeftTop.Column + [PlayerStatusSummaryWindow]::ColEquipDrawOffset) + [PlayerStatusSummaryWindow]::ColEquipNameDrawOffset
                    }
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($null -EQ $Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Cape]) {
                        Return ' None'
                    } Else {
                        Return " $($Script:ThePlayer.EquipmentListing[[EquipmentSlot]::Cape].Name)"
                    }
                })
            }
        ))
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.PlayerInfoDirty -EQ $true) {
            Write-Host "`e[$($this.LeftTop.Row + 1);$($this.LeftTop.Column + 2)H$((Invoke-Command -ScriptBlock {
                Switch($Script:ThePlayer.Gen) {
                    ([Gender]::Male) {
                        Return "$($Script:MaleImageData[$Script:ThePlayer.ProfileImageIndex])"
                    }
                    
                    ([Gender]::Female) {
                        Return "$($Script:FemaleImageData[$Script:ThePlayer.ProfileImageIndex])"
                    }
                    
                    Default {
                        Return "$($Script:MaleImageData[$Script:ThePlayer.ProfileImageIndex])"
                    }
                }
            }))`e[m"
            Write-Host "$($this.PlayerNameAndGenderActual.ToAnsiControlSequenceString())$($this.PlayerStatsActual.ToAnsiControlSequenceString())$($this.PlayerEquipActual.ToAnsiControlSequenceString())"
            $this.PlayerInfoDirty = $false
        }
    }
}
