using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO MILK
#
###############################################################################

Class MTOMilk : MapTileObject {
    [Int]$PlayerHpBonus
    [Boolean]$IsSpoiled

    MTOMilk() {
        $this.Name = 'Milk'
        $this.MapObjName = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString = '2%. We don''t take kindly to whole milk ''round here.'
        $this.Effect = {
            Param(
                [MTOMilk]$Self,
                [Object]$Source
            )

            Switch($Source.PSTypeNames[0]) {
                'Player' {
                    <#
                    Now we're getting into some pretty esoteric stuff here.

                    First, we need to check and see if the Milk is spoiled.
                    #>
                    If($Self.IsSpoiled -EQ $true) {
                        # It is - this will cause the Player's Hp to decrease
                        # Attempt to decrement the Player's Hp by the Hp Bonus
                        If($Source.DecrementHitPoints(-$Self.PlayerHpBonus) -EQ $true) {
                            $Script:TheMessageWindow.WriteMilkUseSpoiledMessage()
                            $Source.RemoveInventoryItemByName($Self.Name)
                        } Else {
                            $Script:TheMessageWindow.WriteMilkUseNotNowMessage()
                        }
                    } Else {
                        # The milk isn't spoiled - attempt to increment the Player's Hp by the Hp Bonus
                        # Attempt to increment the Player's HP by the Hp Bonus
                        If($Script:ThePlayer.IncrementHitPoints($Self.PlayerHpBonus) -EQ $true) {
                            $Script:TheMessageWindow.WriteMilkUseOkayMessage()
                            $Script:ThePlayer.RemoveInventoryItemByName($Self.Name)
                        } Else {
                            $Script:TheMessageWindow.WriteMilkUseNotNowMessage()
                        }
                    }
                }
            }
        }

        # THIS LOOKS STRANGE, BUT NOW WE'RE STILL IN THE CTOR AND THIS SETS, RANDOMLY, SOME STUFF ABOUT THE MLIK
        $a                  = $(Get-Random -Minimum 0 -Maximum 10)
        $this.PlayerHpBonus = 75
        $this.IsSpoiled     = $($a -GE 6 ? $true : $false)
        
        If($this.IsSpoiled -EQ $true) {
            $this.ExamineString      = 'This looks funny. Should I really be drinking this?'
            $this.PlayerEffectString = "-$($this.PlayerHpBonus) HP, 10% chance to inflict Poison"
        } Else {
            $this.PlayerEffectString = "+$($this.PlayerHpBonus) HP"
        }
    }
}

