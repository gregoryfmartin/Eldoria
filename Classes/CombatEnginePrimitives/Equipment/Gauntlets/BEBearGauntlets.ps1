using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEARGAUNTLETS
#
###############################################################################

Class BEBearGauntlets : BEGauntlets {
    BEBearGauntlets() : base() {
        $this.Name               = 'Bear Gauntlets'
        $this.MapObjName         = 'beargauntlets'
        $this.PurchasePrice      = 0
        $this.SellPrice          = 0
        $this.TargetStats        = @{
            [StatId]::Defense      = 999
            [StatId]::MagicDefense = 999
            [StatId]::Accuracy     = 999
        }
        $this.CanAddToInventory  = $true
        $this.ExamineString      = 'The ultimate in fuzzy gauntlets.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
        $this.TargetGender       = [Gender]::Unisex
    }
}
