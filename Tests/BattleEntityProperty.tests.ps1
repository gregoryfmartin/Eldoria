Describe 'Update-EldBep' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\BattleEntityProperty.ps1"
        Initialize-EldVars
    }

    It 'Decrements the Augment Turn Duration by 1 if it''s greater than 0' {
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 5
        
        Update-EldBep -Player -Stat HitPoints

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration').Value) | Should -BeExactly 4

        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 0
    }

    It 'Sets BasePre to Base if it''s currently zero' {
        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 5

        Update-EldBep -Player -Stat HitPoints

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsBasePre').Value) | Should -BeExactly 500

        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsBasePre' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 0
    }

    It 'Sets MaxPre to Max if it''s currently zero' {
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 5

        Update-EldBep -Player -Stat HitPoints

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsMaxPre').Value) | Should -BeExactly 500

        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMaxPre' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 0
    }

    It 'Mutates Max with MaxAugmentValue if AugmentTurnDuration is greater than zero and MaxAugmentActive is false (should be 1000)' {
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsMaxAugmentValue' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 5
        Set-EldVar -Name 'PlayerBepHitPointsMaxAugmentActive' -Data $false

        Update-EldBep -Player -Stat HitPoints

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsMax').Value) | Should -BeExactly 1000

        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMaxAugmentValue' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMaxAugmentActive' -Data $false
    }

    It 'Mutates Base with BaseAugmentValue if AugmentTurnDuration is greater than zero and BaseAugmentActive is false (should be 1000)' {
        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsBaseAugmentValue' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 5
        Set-EldVar -Name 'PlayerBepHitPointsBaseAugmentActive' -Data $false

        Update-EldBep -Player -Stat HitPoints

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsBase').Value) | Should -BeExactly 1000

        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsBaseAugmentValue' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsBaseAugmentActive' -Data $false
    }

    It 'Resets Max properties if AugmentTurnDuration is 0 and they were previously augmented' {
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 1000
        Set-EldVar -Name 'PlayerBepHitPointsMaxPre' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMaxAugmentActive' -Data $true

        Update-EldBep -Player -Stat HitPoints

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsMax').Value) | Should -BeExactly 500

        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMaxPre' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMaxAugmentActive' -Data $false
    }

    It 'Resets Base properties if AugmentTurnDuration is 0 and they were previously augmented' {
        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 1000
        Set-EldVar -Name 'PlayerBepHitPointsBasePre' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsBaseAugmentActive' -Data $true

        Update-EldBep -Player -Stat HitPoints

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsBase').Value) | Should -BeExactly 500

        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsBasePre' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsBaseAugmentActive' -Data $false
    }

    AfterAll {
        Remove-EldVars
    }
}