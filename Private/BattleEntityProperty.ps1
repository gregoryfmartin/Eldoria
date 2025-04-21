using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

. "$PSScriptRoot\Vars.ps1"

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
                If(([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base").Value) -EQ ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max").Value)) {
                    # Don't do anything at this point since Base == Max
                    Return
                }

                If($IncAmt -LE 0) {
                    # Don't do anything at this point since you can't add zero
                    Return
                }

                [Int]$T = ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base").Value) + $IncAmt
                $T = [Math]::Clamp($T, 0, ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max").Value))
                Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base" -Data $T
            } Elseif($DecAmt) {
                If(([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base").Value) -LE 0) {
                    # Don't do anything at this point since Base <= 0
                    Return
                }

                If($DecAmt -LE 0) {
                    # Don't do anything at this point
                    Return
                }

                [Int]$T = ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base").Value) - $DecAmt
                $T = [Math]::Clamp($T, 0, ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max").Value))
                Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base" -Data $T
            }
        } Elseif($Enemy) {
            If(([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Base").Value) -EQ ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Max").Value)) {
                # Don't do anything at this point since Base == Max
                Return
            }

            If($IncAmt -LE 0) {
                # Don't do anything at this point since you can't add zero
                Return
            }

            [Int]$T = ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Base").Value) + $IncAmt
            $T = [Math]::Clamp($T, 0, ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Max").Value))
            Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Base" -Data $T
        } Elseif($DecAmt) {
            If(([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Base").Value) -LE 0) {
                # Don't do anything at this point since Base <= 0
                Return
            }

            If($DecAmt -LE 0) {
                # Don't do anything at this point
                Return
            }

            [Int]$T = ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Base").Value) - $DecAmt
            $T = [Math]::Clamp($T, 0, ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Max").Value))
            Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Base" -Data $T
        }
    }
}

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
                    "PlayerBep$([StatId].GetEnumName($Stat))Base",
                    "PlayerBep$([StatId].GetEnumName($Stat))Max"
                )
            } Elseif($Enemy) {
                Assert-EldVarsExists -Names @(
                    "EnemyBep$([StatId].GetEnumName($Stat))Base",
                    "EnemyBep$([StatId].GetEnumName($Stat))Max"
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
                    Return
                }

                [Int]$T = ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max")) + $IncAmt
                $T = [Math]::Clamp($T, 0, [Int]::MaxValue)
                
                Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max" -Data $T
            } Elseif($DecAmt) {
                If($DecAmt -LE 0) {
                    Return
                }

                [Int]$T = ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max")) - $DecAmt
                $T = [Math]::Clamp($T, 0, [Int]::MaxValue)

                Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max" -Data $T

                If(([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max")) -LT ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base"))) {

                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base" `
                        -Data ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max").Value)

                }
            }
        } Elseif($Enemy) {

        }
    }
}