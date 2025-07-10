using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEARPAULDRONS
#
###############################################################################

Class BEBearPauldrons : BEPauldron {
    BEBearPauldrons() : base() {
        $this.Name               = 'Bear Pauldrons'
        $this.MapObjName         = 'bearpauldrons'
        $this.PurchasePrice      = 0
        $this.SellPrice          = 0
        $this.TargetStats        = @{
            [StatId]::Defense      = 999
            [StatId]::MagicDefense = 999
        }
        $this.CanAddToInventory  = $true
        $this.ExamineString      = 'The ultimate in fuzzy pauldrons.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
        $this.TargetGender       = [Gender]::Unisex
    }
}
