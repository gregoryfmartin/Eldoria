using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEARARMOR
#
###############################################################################

Class BEBearArmor : BEArmor {
    BEBearArmor() : base() {
        $this.Name               = 'Bear Armor'
        $this.MapObjName         = 'beararmor'
        $this.PurchasePrice      = 0
        $this.SellPrice          = 0
        $this.TargetStats        = @{
            [StatId]::Defense      = 999
            [StatId]::MagicDefense = 999
        }
        $this.CanAddToInventory  = $true
        $this.ExamineString      = 'The ultimate in fuzzy armor.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
        $this.TargetGender       = [Gender]::Unisex
    }
}
