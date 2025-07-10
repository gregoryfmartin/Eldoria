using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEARSWORD
#
###############################################################################

Class BEBearSword : BEWeapon {
    BEBearSword() : base() {
        $this.Name               = 'Bear Sword'
        $this.MapObjName         = 'bearsword'
        $this.PurchasePrice      = 0
        $this.SellPrice          = 0
        $this.TargetStats        = @{
            [StatId]::Attack      = 999
            [StatId]::MagicAttack = 999
        }
        $this.CanAddToInventory  = $true
        $this.ExamineString      = 'The ultimate in fuzzy offense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
        $this.TargetGender       = [Gender]::Unisex
    }
}
