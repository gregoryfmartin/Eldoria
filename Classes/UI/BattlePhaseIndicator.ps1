using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BATTLE PHASE INDICATOR
#
###############################################################################

Class BattlePhaseIndicator {
    [Boolean]$IndicatorDrawDirty
    [ATCoordinates]$IndicatorDrawCoords
    [ATStringComposite]$IndicatorStringActual
    [ATStringComposite]$IndicatorStringBlank

    BattlePhaseIndicator() {
        $this.IndicatorDrawCoords = [ATCoordinates]@{
            Row    = 24
            Column = 1
        }
    }

    [Void]Draw(
        [BattleEntity]$ActingEntity
    ) {
        If($this.IndicatorDrawDirty -EQ $true) {
            $this.IndicatorStringBlank = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCApplePinkLight24]::new()
                        Coordinates     = $this.IndicatorDrawCoords
                    }
                    UserData = 'Turn: '
                },
                [ATString]@{
                    UserData   = '              '
                    UseATReset = $true
                }
            ))
            $this.IndicatorStringActual = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCApplePinkLight24]::new()
                        Coordinates     = $this.IndicatorDrawCoords
                    }
                    UserData = 'Turn: '
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $ActingEntity.NameDrawColor
                    }
                    UserData   = "$($ActingEntity.Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$($this.IndicatorStringBlank.ToAnsiControlSequenceString())$($this.IndicatorStringActual.ToAnsiControlSequenceString())"
            # I'M OMITTING THE ORIGINAL CALL I MADE HERE TO RESET THE CURSOR POSITION TO ORIGIN - SEEMS LIKE A SHIT CALL TO MAKE
            $this.IndicatorDrawDirty = $true
        }
    }
}
