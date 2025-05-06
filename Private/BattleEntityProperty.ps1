using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

. "$PSScriptRoot\Vars.ps1"

<#
.SYNOPSIS
A helper function that acts as a quasi-StringBuilder for ELD BEP variable names.

.DESCRIPTION
This function is a crime against humanity, but it's the only real effective method
for abbreviating client code that needs a BEP variable by its name.

.PARAMETER P
A Switch that specifies if we're dealing with the Player. This is intended to be mutually
exclusive with the E parameter.

.PARAMETER E
A Switch that specifies if we're dealing with the Enemy. This is intended to be mutually
exclusive with the P parameter.

.PARAMETER B
A Switch that specifies if we're dealing with the Base variable. This is mutually exclusive with
other parameters.

.PARAMETER Bp
A Switch that specifies if we're dealing with the BasePre variable. This is mutually exclusive
with other parameters.

.PARAMETER Bav
A Switch that specifies if we're dealing with the BaseAugmentValue variable. This is mutually
exclusive with other parameters.

.PARAMETER M
A Switch that specifies if we're dealing with the Max variable. This is mutually exclusive with
other parameters.

.PARAMETER Mp
A Switch that specifies if we're dealing wtih the MaxPre variable. This is mutually exclussive with
other parameters.

.PARAMETER Mav
A Switch that specifies if we're dealing with the MaxAugmentValue variable. This is mutually
exclusive with other parameters.

.PARAMETER Atd
A Switch that specifies if we're dealing with the AugmentTurnDuration variable. This is
mutually exclusive with other parameters.

.PARAMETER Baa
A Switch that specifies if we're dealing with the BaseAugmentActive variable. This is mutually
exclusive with other parameters.

.PARAMETER Maa
A Switch that specifies if we're dealing with the MaxAugmentActive variable. This is mutually
exclusive with other parameters.

.PARAMETER St
A Switch that specifies if we're dealing with the State variable. This is mutually exclusive
with other parameters.

.PARAMETER Vf
A Switch that specifies if we're dealing with the ValidateFunction variable. This is mutually
exclusive with other parameters.

.PARAMETER S
A StatId specifier that determines which stat we're dealing with.

.OUTPUTS
System.String
    A String that can be used to reference an ELD BEP variable name.
#>
Function New-EldBepSuffix {
    [CmdletBinding()]
    Param(
        [Switch]$P,
        [Switch]$E,
        [Switch]$B,
        [Switch]$Bp,
        [Switch]$Bav,
        [Switch]$M,
        [Switch]$Mp,
        [Switch]$Mav,
        [Switch]$Atd,
        [Switch]$Baa,
        [Switch]$Maa,
        [Switch]$St,
        [Switch]$Vf,
        [StatId]$S
    )

    Begin {
        [String]$Base = ''

        If($P) {
            $Base += "PlayerBep$([StatId].GetEnumName($S))"

            If($B) {
                $Base += 'Base'
            } Elseif($Bp) {
                $Base += 'BasePre'
            } Elseif($Bav) {
                $Base += 'BaseAugmentValue'
            } Elseif($M) {
                $Base += 'Max'
            } Elseif($Mp) {
                $Base += 'MaxPre'
            } Elseif($Mav) {
                $Base += 'MaxAugmentValue'
            } Elseif($Atd) {
                $Base += 'AugmentTurnDuration'
            } Elseif($Baa) {
                $Base += 'BaseAugmentActive'
            } Elseif($Maa) {
                $Base += 'MaxAugmentActive'
            } Elseif($St) {
                $Base += 'State'
            } Elseif($Vf) {
                $Base += 'ValidateFunction'
            }
        } Elseif($E) {
            $Base += "EnemyBep$([StatId].GetEnumName($S))"

            If($B) {
                $Base += 'Base'
            } Elseif($Bp) {
                $Base += 'BasePre'
            } Elseif($Bav) {
                $Base += 'BaseAugmentValue'
            } Elseif($M) {
                $Base += 'Max'
            } Elseif($Mp) {
                $Base += 'MaxPre'
            } Elseif($Mav) {
                $Base += 'MaxAugmentValue'
            } Elseif($Atd) {
                $Base += 'AugmentTurnDuration'
            } Elseif($Baa) {
                $Base += 'BaseAugmentActive'
            } Elseif($Maa) {
                $Base += 'MaxAugmentActive'
            } Elseif($St) {
                $Base += 'State'
            } Elseif($Vf) {
                $Base += 'ValidateFunction'
            }
        }

        Return $Base
    }
}

<#
.SYNOPSIS
Maintains the integrity of a Battle Entity Property.

.DESCRIPTION
Battle Entity Properties are laid out "flat" in the ELD variable space. As such, this function will
read/write to the proper variables based on the entity that it's currently targeting.

The basic workflow of this function is as such:

If the current Entity's AugmentTurnDuration is GREATER THAN zero, we assume that the environment this implies
hasn't yet been established and will set it up. The AugmentTurnDuration counter will be decremented by one. If the
Entity's BasePre value is EQUAL TO zero, we assign to it the value of the Entity's Base value. If the Entity's MaxPre
value is EQUAL TO zero, we assign to it the value of the Entity's Max value. If the Entity's MaxAugmentActive flag is
set, we attempt to increment it, clamped to Int::MaxValue, by the value of MaxAugmentValue, then set the MaxAugmentActive
flag. If the Entity's BaseAugmentActive flag is set, we attempt to increment it, clamped to Int::MaxValue, by the value
of BaseAugmentValue, then set the BaseAugmentActive flag.

Alternatively, if AugmentTurnDuration is LESS THAN OR EQUAL TO zero, the Entity's MaxAugmentActive flag is queried. If set,
the value of Max is assigned MaxPre, then MaxPre is reset to zero and the MaxAugmentActive flag is unset. Next, the
BaseAugmentActive flag is queried. If set, the value of Base is assigned BasePre, then BasePre is reset to zero and the
BaseAugmentActive flag is unset.

Finally, if ValidateFunction is available, it's called.

.PARAMETER Player
A Switch specifying if this function is considering the Player entity.

.PARAMETER Enemy
A Switch specifying if this function is considering the Enemy entity.

.PARAMETER Stat
The StatId of the stat to consider for this iteration.
#>
Function Update-EldBep {
    [CmdletBinding()]
    Param(
        [Switch]$Player,

        [Switch]$Enemy,

        [StatId]$Stat
    )

    Begin {
        Try {
            If($Player) {
                Assert-EldVarsExists -Names @(
                    $(New-EldBepSuffix -P -S $Stat -B),
                    $(New-EldBepSuffix -P -S $Stat -Bp),
                    $(New-EldBepSuffix -P -S $Stat -Bav),
                    $(New-EldBepSuffix -P -S $Stat -M),
                    $(New-EldBepSuffix -P -S $Stat -Mp),
                    $(New-EldBepSuffix -P -S $Stat -Mav),
                    $(New-EldBepSuffix -P -S $Stat -Atd),
                    $(New-EldBepSuffix -P -S $Stat -Baa),
                    $(New-EldBepSuffix -P -S $Stat -Maa),
                    $(New-EldBepSuffix -P -S $Stat -St),
                    $(New-EldBepSuffix -P -S $Stat -Vf)
                )
            } Elseif($Enemy) {
                Assert-EldVarsExists -Names @(
                    $(New-EldBepSuffix -E -S $Stat -B),
                    $(New-EldBepSuffix -E -S $Stat -Bp),
                    $(New-EldBepSuffix -E -S $Stat -Bav),
                    $(New-EldBepSuffix -E -S $Stat -M),
                    $(New-EldBepSuffix -E -S $Stat -Mp),
                    $(New-EldBepSuffix -E -S $Stat -Mav),
                    $(New-EldBepSuffix -E -S $Stat -Atd),
                    $(New-EldBepSuffix -E -S $Stat -Baa),
                    $(New-EldBepSuffix -E -S $Stat -Maa),
                    $(New-EldBepSuffix -E -S $Stat -St),
                    $(New-EldBepSuffix -E -S $Stat -Vf)
                )
            }
        } Catch {
            Throw $_
        }
    }

    Process {
        If($Player) {
            If(([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Atd)).Value) -GT 0) {

                # With this statement here, it's not possible to use the postfix decrement operator.
                # It will reset the value.
                Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Atd) `
                    -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Atd)).Value - 1)

                # I don't think I like this syntax. It kind of obfuscates the intent of the statement given the
                # function names.
                # ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))AugmentTurnDuration").Value--)

                If(([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Bp)).Value) -EQ 0) {

                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Bp) `
                        -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B)).Value)

                }

                If(([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Mp)).Value) -EQ 0) {

                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Mp) `
                        -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M)).Value)

                }

                If(([Boolean](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Maa)).Value) -EQ $false) {

                    [Int]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M)).Value) + ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Mav)).Value)
                    $T = [Math]::Clamp($T, 0, [Int]::MaxValue)
                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M) -Data $T
                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Maa) -Data $true

                }

                If(([Boolean](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Baa)).Value) -EQ $false) {

                    [Int]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B)).Value) + ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Bav)).Value)
                    $T = [Math]::Clamp($T, 0, [Int]::MaxValue)
                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B) -Data $T
                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Baa) -Data $true

                }
            } Else {
                If(([Boolean](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Maa)).Value) -EQ $true) {

                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M) `
                        -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Mp)).Value)
                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Mp) -Data 0
                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Maa) -Data $false

                }

                If(([Boolean](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Baa)).Value) -EQ $true) {

                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B) `
                        -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Bp)).Value)
                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Bp) -Data 0
                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Baa) -Data $false

                }
            }

            Invoke-Command ([ScriptBlock](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -Vf)).Value)
        } Elseif($Enemy) {
            If(([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Atd)).Value) -GT 0) {

                # With this statement here, it's not possible to use the postfix decrement operator.
                # It will reset the value.
                Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Atd) `
                    -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Atd)).Value - 1)

                # I don't think I like this syntax. It kind of obfuscates the intent of the statement given the
                # function names.
                # ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))AugmentTurnDuration").Value--)

                If(([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Bp)).Value) -EQ 0) {

                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Bp) `
                        -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B)).Value)

                }

                If(([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Mp)).Value) -EQ 0) {

                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Mp) `
                        -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M)).Value)

                }

                If(([Boolean](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Maa)).Value) -EQ $false) {

                    [Int]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M)).Value) + ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Mav)).Value)
                    $T = [Math]::Clamp($T, 0, [Int]::MaxValue)
                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M) -Data $T
                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Maa) -Data $true

                }

                If(([Boolean](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Baa)).Value) -EQ $false) {

                    [Int]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B)).Value) + ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Bav)).Value)
                    $T = [Math]::Clamp($T, 0, [Int]::MaxValue)
                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B) -Data $T
                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Baa) -Data $true

                }
            } Else {
                If(([Boolean](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Maa)).Value) -EQ $true) {

                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M) `
                        -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Mp)).Value)
                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Mp) -Data 0
                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Maa) -Data $false

                }

                If(([Boolean](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Baa)).Value) -EQ $true) {

                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B) `
                        -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Bp)).Value)
                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Bp) -Data 0
                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Baa) -Data $false

                }
            }

            Invoke-Command ([ScriptBlock](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -Vf)).Value)
        }
    }
}

<#
.SYNOPSIS
Increments or decrements the Base property of a specific stat of a specific entity.

.PARAMETER Player
A Switch specifying if this function is considering the Player entity.

.PARAMETER Enemy
A Switch specifying if this function is considering the Enemy entity.

.PARAMETER Stat
The StatId of the stat to consider for this iteration.

.PARAMETER IncAmt
The amount to increment the Base property by. Mutually exclusive with the DecAmt parameter.

.PARAMETER DecAmt
The amount to decrement the Base property by. Mutually exclusive with the IncAmt parameter.
#>
Function Update-EldBepBase {
    [CmdletBinding()]
    Param(
        [Switch]$Player,

        [Switch]$Enemy,

        [StatId]$Stat,

        [Parameter(ParameterSetName = 'Increment')]
        [Int]$IncAmt = 0,

        [Parameter(ParameterSetName = 'Decrement')]
        [Int]$DecAmt = 0
    )

    Begin {
        Try {
            If($Player) {
                Assert-EldVarsExists -Names @(
                    $(New-EldBepSuffix -P -S $Stat -B),
                    $(New-EldBepSuffix -P -S $Stat -M)
                )
            } Elseif($Enemy) {
                Assert-EldVarsExists -Names @(
                    $(New-EldBepSuffix -E -S $Stat -B)
                    $(New-EldBepSuffix -E -S $Stat -M)
                )
            }
        } Catch {
            Throw $_
        }
    }

    Process {
        If($Player) {
            If($IncAmt) {
                If(([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B)).Value) `
                        -EQ ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M)).Value)) {
                    # Don't do anything at this point since Base == Max
                    Return
                }

                If($IncAmt -LE 0) {
                    # Don't do anything at this point since you can't add zero
                    Return
                }

                [Int64]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B)).Value) + $IncAmt
                $T      = [Math]::Clamp($T, 0, ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M)).Value))
                Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B) -Data $T
            } Elseif($DecAmt) {
                If(([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B)).Value) -LE 0) {
                    # Don't to anything at this point since Base <= 0
                    Return
                }

                If($DecAmt -LE 0) {
                    # Don't do anything at this point
                    Return
                }

                [Int64]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B)).Value) - $DecAmt
                $T      = [Math]::Clamp($T, 0, ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M)).Value))
                
                Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B) -Data $T
            }
        } Elseif($Enemy) {
            If($IncAmt) {
                If(([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B)).Value) `
                        -EQ ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M)).Value)) {
                    # Don't do anything at this point since Base == Max
                    Return
                }

                If($IncAmt -LE 0) {
                    # Don't do anything at this point since you can't add zero
                    Return
                }

                [Int64]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B)).Value) + $IncAmt
                $T      = [Math]::Clamp($T, 0, ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M)).Value))
                Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B) -Data $T
            } Elseif($DecAmt) {
                If(([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B)).Value) -LE 0) {
                    # Don't to anything at this point since Base <= 0
                    Return
                }

                If($DecAmt -LE 0) {
                    # Don't do anything at this point
                    Return
                }

                [Int64]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B)).Value) - $DecAmt
                $T      = [Math]::Clamp($T, 0, ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M)).Value))
                Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B) -Data $T
            }
        }
    }
}

<#
.SYNOPSIS
Increments or decrements the Max property of a specific stat of a specific entity.

.PARAMETER Player
A Switch specifying if this function is considering the Player entity.

.PARAMETER Enemy
A Switch specifying if this function is considering the Enemy entity.

.PARAMETER Stat
The StatId of the stat to consider for this iteration.

.PARAMETER IncAmt
The amount to increment the Max property by. Mutually exclusive with the DecAmt parameter.

.PARAMETER DecAmt
The amount to decrement the Max property by. Mutually exclusive with the IncAmt parameter.
#>
Function Update-EldBepMax {
    [CmdletBinding()]
    Param(
        [Switch]$Player,

        [Switch]$Enemy,

        [StatId]$Stat,

        [Parameter(ParameterSetName = 'Increment')]
        [Int]$IncAmt = 0,

        [Parameter(ParameterSetName = 'Decrement')]
        [Int]$DecAmt = 0
    )

    Begin {
        Try {
            If($Player) {
                Assert-EldVarsExists -Names @(
                    $(New-EldBepSuffix -P -S $Stat -B),
                    $(New-EldBepSuffix -P -S $Stat -M)
                )
            } Elseif($Enemy) {
                Assert-EldVarsExists -Names @(
                    $(New-EldBepSuffix -E -S $Stat -B),
                    $(New-EldBepSuffix -E -S $Stat -M)
                )
            }
        } Catch {
            Throw $_
        }
    }


    Process {
        If($Player) {
            If($IncAmt) {
                If($IncAmt -LE 0) {
                    Return $null
                }

                [Int64]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M)).Value) + $IncAmt
                $T        = [Math]::Clamp($T, 0, [Int]::MaxValue)
                
                Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M) -Data $T
            } Elseif($DecAmt) {
                If($DecAmt -LE 0) {
                    Return $null
                }

                [Int64]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M)).Value) - $DecAmt
                $T      = [Math]::Clamp($T, 0, [Int]::MaxValue)

                Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M) -Data $T

                If(([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M)).Value) `
                        -LT ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B)).Value)) {
                    
                    Set-EldVar -Name $(New-EldBepSuffix -P -S $Stat -B) `
                            -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -P -S $Stat -M)).Value)

                }
            }
        } Elseif($Enemy) {
            If($IncAmt) {
                If($IncAmt -LE 0) {
                    Return $null
                }

                [Int64]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M)).Value) + $IncAmt
                $T        = [Math]::Clamp($T, 0, [Int]::MaxValue)
                
                Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M) -Data $T
            } Elseif($DecAmt) {
                If($DecAmt -LE 0) {
                    Return $null
                }

                [Int]$T = ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M)).Value) - $DecAmt
                $T      = [Math]::Clamp($T, 0, [Int]::MaxValue)

                Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M) -Data $T

                If(([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M)).Value) `
                        -LT ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B)).Value)) {
                    
                    Set-EldVar -Name $(New-EldBepSuffix -E -S $Stat -B) `
                            -Data ([Int](Get-EldVar -Name $(New-EldBepSuffix -E -S $Stat -M)).Value)

                }
            }
        }
    }
}