using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

. "$PSScriptRoot\Vars.ps1"

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
                    "PlayerBep$([StatId].GetEnumName($Stat))Base",
                    "PlayerBep$([StatId].GetEnumName($Stat))BasePre",
                    "PlayerBep$([StatId].GetEnumName($Stat))BaseAugmentValue",
                    "PlayerBep$([StatId].GetEnumName($Stat))Max",
                    "PlayerBep$([StatId].GetEnumName($Stat))MaxPre",
                    "PlayerBep$([StatId].GetEnumName($Stat))MaxAugmentValue",
                    "PlayerBep$([StatId].GetEnumName($Stat))AugmentTurnDuration",
                    "PlayerBep$([StatId].GetEnumName($Stat))BaseAugmentActive",
                    "PlayerBep$([StatId].GetEnumName($Stat))MaxAugmentActive",
                    "PlayerBep$([StatId].GetEnumName($Stat))State",
                    "PlayerBep$([StatId].GetEnumName($Stat))ValidateFunction"
                )
            } Elseif($Enemy) {
                Assert-EldVarsExists -Names @(
                    "EnemyBep$([StatId].GetEnumName($Stat))Base",
                    "EnemyBep$([StatId].GetEnumName($Stat))BasePre",
                    "EnemyBep$([StatId].GetEnumName($Stat))BaseAugmentValue",
                    "EnemyBep$([StatId].GetEnumName($Stat))Max",
                    "EnemyBep$([StatId].GetEnumName($Stat))MaxPre",
                    "EnemyBep$([StatId].GetEnumName($Stat))MaxAugmentValue",
                    "EnemyBep$([StatId].GetEnumName($Stat))AugmentTurnDuration",
                    "EnemyBep$([StatId].GetEnumName($Stat))BaseAugmentActive",
                    "EnemyBep$([StatId].GetEnumName($Stat))MaxAugmentActive",
                    "EnemyBep$([StatId].GetEnumName($Stat))State",
                    "EnemyBep$([StatId].GetEnumName($Stat))ValidateFunction"
                )
            }
        } Catch {
            Throw $_
        }
    }

    Process {
        If($Player) {
            If(([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))AugmentTurnDuration").Value) -GT 0) {

                # With this statement here, it's not possible to use the postfix decrement operator.
                # It will reset the value.
                Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))AugmentTurnDuration" `
                    -Data ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))AugmentTurnDuration").Value - 1)

                # I don't think I like this syntax. It kind of obfuscates the intent of the statement given the
                # function names.
                # ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))AugmentTurnDuration").Value--)

                If(([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))BasePre").Value) -EQ 0) {

                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))BasePre" `
                        -Data ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base").Value)

                }

                If(([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))MaxPre").Value) -EQ 0) {

                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))MaxPre" `
                        -Data ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max").Value)

                }

                If(([Boolean](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))MaxAugmentActive").Value) -EQ $false) {

                    [Int]$T = ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max").Value) + ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))MaxAugmentValue").Value)
                    $T = [Math]::Clamp($T, 0, [Int]::MaxValue)
                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max" -Data $T
                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))MaxAugmentActive" -Data $true

                }

                If(([Boolean](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))BaseAugmentActive").Value) -EQ $false) {

                    [Int]$T = ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base").Value) + ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))BaseAugmentValue").Value)
                    $T = [Math]::Clamp($T, 0, [Int]::MaxValue)
                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base" -Data $T
                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))BaseAugmentActive" -Data $true

                }
            } Else {
                If(([Boolean](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))MaxAugmentActive").Value) -EQ $true) {

                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Max" `
                        -Data ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))MaxPre").Value)
                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))MaxPre" -Data 0
                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))MaxAugmentActive" -Data $false

                }

                If(([Boolean](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))BaseAugmentActive").Value) -EQ $true) {

                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))Base" `
                        -Data ([Int](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))BasePre").Value)
                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))BasePre" -Data 0
                    Set-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))BaseAugmentActive" -Data $false

                }
            }

            Invoke-Command ([ScriptBlock](Get-EldVar -Name "PlayerBep$([StatId].GetEnumName($Stat))ValidateFunction").Value)
        } Elseif($Enemy) {
            If(([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))AugmentTurnDuration").Value) -GT 0) {

                Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))AugmentTurnDuration" `
                    -Data ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))AugmentTurnDuration").Value - 1)

                If(([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))BasePre").Value) -EQ 0) {

                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))BasePre" `
                        -Data ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Base").Value)

                }

                If(([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))MaxPre").Value) -EQ 0) {

                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))MaxPre" `
                        -Data ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Max").Value)

                }

                If(([Boolean](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))MaxAugmentActive").Value) -EQ $false) {

                    [Int]$T = ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Max").Value) + ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))MaxAugmentValue").Value)
                    $T = [Math]::Clamp($T, 0, [Int]::MaxValue)
                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Max" -Data $T
                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))MaxAugmentActive" -Data $true

                }

                If(([Boolean](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))BaseAugmentActive").Value) -EQ $false) {

                    [Int]$T = ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Base").Value) + ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))BaseAugmentValue").Value)
                    $T = [Math]::Clamp($T, 0, [Int]::MaxValue)
                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Base" -Data $T
                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))BaseAugmentActive" -Data $true

                }
            } Else {
                If(([Boolean](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))MaxAugmentActive").Value) -EQ $true) {

                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Max" `
                        -Data ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))MaxPre").Value)
                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))MaxPre" -Data 0
                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))MaxAugmentActive" -Data $false

                }

                If(([Boolean](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))BaseAugmentActive").Value) -EQ $true) {

                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))Base" `
                        -Data ([Int](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))BasePre").Value)
                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))BasePre" -Data 0
                    Set-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))BaseAugmentActive" -Data $false

                }
            }

            Invoke-Command ([ScriptBlock](Get-EldVar -Name "EnemyBep$([StatId].GetEnumName($Stat))ValidateFunction").Value)
        }
    }
}

Function Update-EldBepBase {
    Param(
        [Switch]$Player,

        [Switch]$Enemy,

        [StatId]$Stat,

        [Parameter(ParameterSetName = 'Increment')]
        [Int]$IncAmt = 0,

        [Parameter(ParameterSetName = 'Decrement')]
        [Int]$DecAmt = 0
    )
}