using namespace System

Set-StrictMode -Version Latest

#//////////////////////////////////////////////////////////////////////////////
#
# BATTLE ENTITY PROPERTY
#
# DESCRIBES A PROPERTY OF A BATTLE ENTITY. THIS IS A NUMERIC VALUE THAT HAS A
# MINIMUM AND MAXIMUM, SUPPORTS TEMPORARY AUGMENTATION, AND IS CAPABLE OF
# MAINTAINING ITS OWN STATE.
#
#//////////////////////////////////////////////////////////////////////////////
Class BattleEntityProperty {
    Static [Single]$StatNumThresholdCaution          = 0.6D
    Static [Single]$StatNumThresholdDanger           = 0.3D
    Static [ConsoleColor24]$StatNumDrawColorSafe     = [CCAppleGreenLight24]::new()
    Static [ConsoleColor24]$StatNumDrawColorCaution  = [CCAppleYellowLight24]::new()
    Static [ConsoleColor24]$StatNumDrawColorDanger   = [CCAppleRedLight24]::new()
    Static [ConsoleColor24]$StatAugDrawColorPositive = [CCAppleCyanLight24]::new()
    Static [ConsoleColor24]$StatAugDrawColorNegative = [CCApplePurpleDark24]::new()

    [Int]$Base
    [Int]$BasePre
    [Int]$BaseAugmentValue
    [Int]$Max
    [Int]$MaxPre
    [Int]$MaxAugmentValue
    [Int]$AugmentTurnDuration
    [Boolean]$BaseAugmentActive
    [Boolean]$MaxAugmentActive
    [StatNumberState]$State
    [ScriptBlock]$ValidateFunction

    BattleEntityProperty() {
        $this.Base                = 0
        $this.BasePre             = 0
        $this.BaseAugmentValue    = 0
        $this.Max                 = 0
        $this.MaxPre              = 0
        $this.MaxAugmentValue     = 0
        $this.AugmentTurnDuration = 0
        $this.BaseAugmentActive   = $false
        $this.MaxAugmentActive    = $false
        $this.State               = [StatNumberState]::Normal
        $this.ValidateFunction    = $null
    }

    # THIS CTOR CAN LIKELY GO AWAY
    # BattleEntityProperty(
    #     [Int]$Base,
    #     [Int]$BasePre,
    #     [Int]$BaseAugmentValue,
    #     [Int]$Max,
    #     [Int]$MaxPre,
    #     [Int]$MaxAugmentValue,
    #     [Int]$AugmentTurnDuration,
    #     [Boolean]$BaseAugmentActive,
    #     [Boolean]$MaxAugmentActive,
    #     [StatNumberState]$State,
    #     [ScriptBlock]$ValidateFunction
    # ) {
    #     $this.Base                = $Base
    #     $this.BasePre             = $BasePre
    #     $this.BaseAugmentValue    = $BaseAugmentValue
    #     $this.Max                 = $Max
    #     $this.MaxPre              = $MaxPre
    #     $this.MaxAugmentValue     = $MaxAugmentValue
    #     $this.AugmentTurnDuration = $AugmentTurnDuration
    #     $this.BaseAugmentActive   = $BaseAugmentActive
    #     $this.MaxAugmentActive    = $MaxAugmentActive
    #     $this.State               = $State
    #     $this.ValidateFunction    = $ValidateFunction
    # }

    [Void]Update() {
        If($this.AugmentTurnDuration -GT 0) {
            $this.AugmentTurnDuration--
            If($this.BasePre -EQ 0) {
                $this.BasePre = $this.Base
            }
            If($this.MaxPre -EQ 0) {
                $this.MaxPre = $this.Max
            }
            If($this.MaxAugmentActive -EQ $false) {
                [Int]$t                = $this.Max + $this.MaxAugmentValue
                $t                     = [Math]::Clamp($t, 0, [Int]::MaxValue)
                $this.Max              = $t
                $this.MaxAugmentActive = $true
            }
            If($this.BaseAugmentActive -EQ $false) {
                [Int]$t                 = $this.Base + $this.BaseAugmentValue
                $t                      = [Math]::Clamp($t, 0, [Int]::MaxValue)
                $this.Base              = $t
                $this.BaseAugmentActive = $true
            }
        } Else {
            If($this.MaxAugmentActive -EQ $true) {
                $this.Max              = $this.MaxPre
                $this.MaxPre           = 0
                $this.MaxAugmentActive = $false
            }
            If($this.BaseAugmentActive -EQ $true) {
                $this.Base              = $this.BasePre
                $this.BasePre           = 0
                $this.BaseAugmentActive = $false
            }
        }

        Invoke-Command $this.ValidateFunction -ArgumentList $this
    }

    <#
    .OUTPUTS
    Integer
        -1 - The value of IncAmt is less than or equal to zero.
        -2 - The value of Base is equal to Max (no need to increment Base at this point)
        0  - Base was successfully incremented by IncAmt
    #>
    [Int]IncrementBase(
        [Int]$IncAmt
    ) {
        If($IncAmt -LE 0) {
            Return -1
        }
        If($this.Base -EQ $this.Max) {
            Return -2
        }
        [Int]$t    = $this.Base + $IncAmt
        $t         = [Math]::Clamp($t, 0, $this.Max) # This should work regardless if BaseAugmentActive = true
        $this.Base = $t

        Return 0
    }

    <#
    .OUTPUTS
    Integer
        -1 - The value of DecAmt is greater than or equal to zero.
        -2 - The value of Base is less than or equal to zero.
        0  - Base was successfully decremented by DecAmt.
    #>
    [Int]DecrementBase(
        [Int]$DecAmt
    ) {
        If($DecAmt -GE 0) {
            Return -1
        }
        If($this.Base -LE 0) {
            Return -2
        }
        [Int]$t    = $this.Base + $DecAmt
        $t         = [Math]::Clamp($t, 0, $this.Max)
        $this.Base = $t
        
        Return 0
    }

    <# 
    .OUTPUTS
    Integer
        -1 - The value of IncAmt is less than or equal to zero.
        0  - Max was successfully incremented by IncAmt.
    #>
    [Int]IncrementMax(
        [Int]$IncAmt
    ) {
        If($IncAmt -LE 0) {
            Return -1
        }
        $this.Max += $IncAmt

        Return 0
    }

    <#
    .OUTPUTS
    Integer
        -1 - The value of DecAmt is greater than or equal to zero.
        0  - Max was successfully decremented by DecAmt.
    #>
    [Int]DecrementMax(
        [Int]$DecAmt
    ) {
        If($DecAmt -GE 0) {
            Return -1
        }
        [Int]$t   = $this.Max - $DecAmt
        $t        = [Math]::Clamp($t, 0, [Int]::MaxValue)
        $this.Max = $t
        If($this.Max -LT $this.Base) {
            $this.Base = $this.Max
        }

        Return 0
    }
}