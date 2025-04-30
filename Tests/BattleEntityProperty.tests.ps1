Describe 'New-EldBepSuffix' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\BattleEntityProperty.ps1"
        Initialize-EldVars
    }

    It 'Returns a Player BEP Hit Points prefix when requested' {
        (New-EldBepSuffix -P -S HitPoints) | Should -BeExactly 'PlayerBepHitPoints'
    }

    It 'Returns an Enemy BEP Hit Points prefix when requested' {
        (New-EldBepSuffix -E -S HitPoints) | Should -BeExactly 'EnemyBepHitPoints'
    }

    It 'Returns a Player BEP Hit Points Base Augment Active prefix when requested' {
        (New-EldBepSuffix -P -S HitPoints -Baa) | Should -BeExactly 'PlayerBepHitPointsBaseAugmentActive'
    }

    AfterAll {
        Remove-EldVars
    }
}

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

Describe 'Update-EldBepBase' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\BattleEntityProperty.ps1"
        Initialize-EldVars
    }

    It 'Increments Base by 100 if Base is less than Max (should be 600)' {
        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 1500

        Update-EldBepBase -Player -Stat HitPoints -IncAmt 100

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsBase').Value) | Should -BeExactly 600

        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    It 'Decrements Base by 100 if Base is greater than zero (should be 400)' {
        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500

        Update-EldBepBase -Player -Stat HitPoints -DecAmt 100

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsBase').Value) | Should -BeExactly 400

        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    It 'Sets Base to Max if an increment result is greater than Max' {
        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 400
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500

        Update-EldBepBase -Player -Stat HitPoints -IncAmt 500

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsBase').Value) | Should -BeExactly 500

        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    It 'Sets Base to 0 if a decrement result is less than zero' {
        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500

        Update-EldBepBase -Player -Stat HitPoints -DecAmt 600

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsBase').Value) | Should -BeExactly 0

        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    It 'Does nothing if for an increment op IncAmt is less than or equal to zero' {
        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 400
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500

        Update-EldBepBase -Player -Stat HitPoints -IncAmt -50

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsBase').Value) | Should -BeExactly 400

        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    It 'Does nothing if for a decrement op DecAmt is less than or equal to zero' {
        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 500
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500

        Update-EldBepBase -Player -Stat HitPoints -DecAmt -50

        ([Int](Get-EldVar -Name 'PlayerBepHitPointsBase').Value) | Should -BeExactly 500

        Set-EldVar -Name 'PlayerBepHitPointsBase' -Data 0
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    AfterAll {
        Remove-EldVars
    }
}

Describe 'Update-EldBepMax' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\BattleEntityProperty.ps1"
        Initialize-EldVars
    }

    It 'Returns nothing if IncAmt is LESS THAN OR EQUAL TO zero' {
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500

        Update-EldBepMax -Player -Stat HitPoints -IncAmt -50 | Should -BeNullOrEmpty

        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    It 'Increments Max by 100' {
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500

        Update-EldBepMax -Player -Stat HitPoints -IncAmt 100

        (Get-EldVar -Name 'PlayerBepHitPointsMax').Value | Should -BeExactly 600

        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    It 'Clamps Max to Int.MaxValue if increment is greater than Int.MaxValue' {
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500

        Update-EldBepMax -Player -Stat HitPoints -IncAmt $([Int]::MaxValue)

        (Get-EldVar -Name 'PlayerBepHitPointsMax').Value | Should -BeExactly $([Int]::MaxValue)

        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    It 'Returns nothing if DecAmt is LESS THAN OR EQUAL TO 0' {
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500

        Update-EldBepMax -Player -Stat HitPoints -DecAmt -50 | Should -BeNullOrEmpty

        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    It 'Decrements Max by 100' {
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500

        Update-EldBepMax -Player -Stat HitPoints -DecAmt 100

        (Get-EldVar -Name 'PlayerBepHitPointsMax').Value | Should -BeExactly 400

        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    It 'Clamps Max to 0 if decrement is less than zero' {
        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 500

        Update-EldBepMax -Player -Stat HitPoints -DecAmt 6000

        (Get-EldVar -Name 'PlayerBepHitPointsMax').Value | Should -BeExactly 0

        Set-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
    }

    AfterAll {
        Remove-EldVars
    }
}