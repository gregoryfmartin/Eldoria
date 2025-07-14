using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFINITYIITURTLESWORD
#
###############################################################################

Class BEInfinityIITurtleSword : BEWeapon {
    BEInfinityIITurtleSword() : base() {
        $this.Name               = 'Infinity II Turtle Sword'
        $this.MapObjName         = 'infinityiiturtsword'
        $this.PurchasePrice      = 750000
        $this.SellPrice          = 0
        $this.TargetStats        = @{
            [StatId]::Attack      = 240
            [StatId]::MagicAttack = 240
        }
        $this.CanAddToInventory  = $true
        $this.ExamineString      = 'It spawns 6 turtles that help you, and stay with you.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
        $this.TargetGender       = [Gender]::Unisex
    }
}
