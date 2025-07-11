using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# BATTLE STATUS MESSAGE WINDOW
#
###############################################################################

Class BattleStatusMessageWindow : WindowBase {
    Static [Int]$MessageHistoryARef = 0
    Static [Int]$MessageHistoryBRef = 1
    Static [Int]$MessageHistoryCRef = 2
    Static [Int]$MessageHistoryDRef = 3
    Static [Int]$MessageHistoryERef = 4
    Static [Int]$WindowLTRow        = 18
    Static [Int]$WindowLTColumn     = 22
    Static [Int]$WindowRBRow        = 24
    Static [Int]$WindowRBColumn     = 81

    Static [String]$MessageBlankActual = '                                                         '
    Static [String]$WindowTitle        = 'Log'

    Static [Single]$MessageSleepTime = 0.2

    [Boolean]$MessageADirty
    [Boolean]$MessageBDirty
    [Boolean]$MessageCDirty
    [Boolean]$MessageDDirty
    [Boolean]$MessageEDirty
    [ATString]$MessageBlank
    [ATCoordinates]$MessageADrawCoords
    [ATCoordinates]$MessageBDrawCoords
    [ATCoordinates]$MessageCDrawCoords
    [ATCoordinates]$MessageDDrawCoords
    [ATCoordinates]$MessageEDrawCoords
    [ATStringComposite[]]$MessageHistory

    BattleStatusMessageWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [BattleStatusMessageWindow]::WindowLTRow
            Column = [BattleStatusMessageWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [BattleStatusMessageWindow]::WindowRBRow
            Column = [BattleStatusMessageWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()

        $this.SetupTitle([BattleStatusMessageWindow]::WindowTitle, [CCTextDefault24]::new())

        $this.MessageADirty = $false
        $this.MessageBDirty = $false
        $this.MessageCDirty = $false
        $this.MessageDDirty = $false
        $this.MessageEDirty = $false

        $this.MessageBlank = [ATString]@{
            Prefix     = [ATStringPrefix]::new()
            UserData   = "$([BattleStatusMessageWindow]::MessageBlankActual)"
            UseATReset = $true
        }

        $this.MessageADrawCoords = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.LeftTop.Column + 1
        }
        $this.MessageBDrawCoords = [ATCoordinates]@{
            Row    = $this.MessageADrawCoords.Row + 1
            Column = $this.MessageADrawCoords.Column
        }
        $this.MessageCDrawCoords = [ATCoordinates]@{
            Row    = $this.MessageBDrawCoords.Row + 1
            Column = $this.MessageBDrawCoords.Column
        }
        $this.MessageDDrawCoords = [ATCoordinates]@{
            Row    = $this.MessageCDrawCoords.Row + 1
            Column = $this.MessageCDrawCoords.Column
        }
        $this.MessageEDrawCoords = [ATCoordinates]@{
            Row    = $this.MessageDDrawCoords.Row + 1
            Column = $this.MessageDDrawCoords.Column
        }

        $this.MessageHistory = [ATStringComposite[]](
            [ATStringComposite]::new(),
            [ATStringComposite]::new(),
            [ATStringComposite]::new(),
            [ATStringComposite]::new(),
            [ATStringComposite]::new()
        )
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryARef].CompositeActual[0].Prefix.Coordinates = $this.MessageADrawCoords
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryBRef].CompositeActual[0].Prefix.Coordinates = $this.MessageBDrawCoords
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryCRef].CompositeActual[0].Prefix.Coordinates = $this.MessageCDrawCoords
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryDRef].CompositeActual[0].Prefix.Coordinates = $this.MessageDDrawCoords
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryERef].CompositeActual[0].Prefix.Coordinates = $this.MessageEDrawCoords
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.MessageEDirty -EQ $true) {
            $this.MessageBlank.Prefix.Coordinates = $this.MessageEDrawCoords
            Write-Host "$($this.MessageBlank.ToAnsiControlSequenceString())$($this.MessageEDrawCoords.ToAnsiControlSequenceString())$($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryERef].ToAnsiControlSequenceString())"
            $this.MessageEDirty = $false
            Start-Sleep -Seconds $([BattleStatusMessageWindow]::MessageSleepTime)
        }
        If($this.MessageDDirty -EQ $true) {
            $this.MessageBlank.Prefix.Coordinates = $this.MessageDDrawCoords
            Write-Host "$($this.MessageBlank.ToAnsiControlSequenceString())$($this.MessageDDrawCoords.ToAnsiControlSequenceString())$($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryDRef].ToAnsiControlSequenceString())"
            $this.MessageDDirty = $false
            Start-Sleep -Seconds $([BattleStatusMessageWindow]::MessageSleepTime)
        }
        If($this.MessageCDirty -EQ $true) {
            $this.MessageBlank.Prefix.Coordinates = $this.MessageCDrawCoords
            Write-Host "$($this.MessageBlank.ToAnsiControlSequenceString())$($this.MessageCDrawCoords.ToAnsiControlSequenceString())$($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryCRef].ToAnsiControlSequenceString())"
            $this.MessageCDirty = $false
            Start-Sleep -Seconds $([BattleStatusMessageWindow]::MessageSleepTime)
        }
        If($this.MessageBDirty -EQ $true) {
            $this.MessageBlank.Prefix.Coordinates = $this.MessageBDrawCoords
            Write-Host "$($this.MessageBlank.ToAnsiControlSequenceString())$($this.MessageBDrawCoords.ToAnsiControlSequenceString())$($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryBRef].ToAnsiControlSequenceString())"
            $this.MessageBDirty = $false
            Start-Sleep -Seconds $([BattleStatusMessageWindow]::MessageSleepTime)
        }
        If($this.MessageADirty -EQ $true) {
            $this.MessageBlank.Prefix.Coordinates = $this.MessageADrawCoords
            Write-Host "$($this.MessageBlank.ToAnsiControlSequenceString())$($this.MessageADrawCoords.ToAnsiControlSequenceString())$($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryARef].ToAnsiControlSequenceString())"
            $this.MessageADirty = $false
            Start-Sleep -Seconds $([BattleStatusMessageWindow]::MessageSleepTime + 0.4)
        }
    }

    [Void]WriteMessageComposite(
        [ATString[]]$ATComposite
    ) {
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryARef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryBRef].CompositeActual)
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryBRef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryCRef].CompositeActual)
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryCRef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryDRef].CompositeActual)
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryDRef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryERef].CompositeActual)
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryERef]                 = [ATStringComposite]::new($ATComposite)

        $this.MessageADirty = $true
        $this.MessageBDirty = $true
        $this.MessageCDirty = $true
        $this.MessageDDirty = $true
        $this.MessageEDirty = $true
    }

    [Void]WriteNotEnoughMpMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVYellowADark24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = 'Not enough MP!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteEntityUsesMessage(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' uses '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarSwc(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' was successful! '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = 'CRITICAL!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarAff(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' was successful! '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = 'AFFINITY!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarCritAff(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' was successful! '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Decorations = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = 'CRIT AND AFFINITY!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarSuccess(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' was successful!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarFailMissed(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' missed!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarFailFailed(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' failed!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatPhysical(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' hit '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalFire(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' burned '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalWater(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' soaked '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalEarth(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' stoned '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalWind(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' sheared '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalLight(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' cast holy power on '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalDark(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' cast unholy power on '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalIce(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' froze '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatMagicPoison(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' poisoned '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatMagicConfuse(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' confused '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = '!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatMagicSleep(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' put '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' to sleep!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatMagicAging(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' made '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' grow old!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatMagicHealing(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        If($Originator == $Target) {
            # Healed themselves
            $this.WriteMessageComposite(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Originator.NameDrawColor
                    }
                    UserData   = "$($Originator.Name)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = ' healed themself '
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                    }
                    UserData   = "$($Result.ActionEfffectSum)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = '!'
                    UseATReset = $true
                }
            ))
        } Else {
            # Healed Target
            $this.WriteMessageComposite(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Originator.NameDrawColor
                    }
                    UserData   = "$($Originator.Name)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = ' healed '
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Target.NameDrawColor
                    }
                    UserData   = "$($Target.Name)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = ' for '
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                    }
                    UserData   = "$($Result.ActionEfffectSum)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = '!'
                    UseATReset = $true
                }
            ))
        }
    }

    [Void]WriteEntityCantActMessage(
        [BattleEntity]$Originator
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData = "$($Originator.Name)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' is unable to act!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBattleWonMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'You''ve won the battle!'
                UseATReset = $true
            }
        ))
    }
	
	[Void]WriteBattleLostMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'You''ve lost the battle.'
				UseATReset = $true
			}
		))
	}
	
	[Void]WriteGameOverMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'GAME OVER'
				UseATReset = $true
			}
		))
	}

    [Void]WriteBattleEndPrompt() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'Press ''Enter'' to exit.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteSpoilsMessage(
        [EnemyBattleEntity]$Opponent
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Opponent.NameDrawColor
                }
                UserData   = "$($Opponent.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' dropped '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($Opponent.SpoilsGold)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' gold.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteItemsFoundMessage(
        [String]$ItemNames
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'Also found '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($ItemNames)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = '.'
                UseATReset = $true
            }
        ))
    }
}
