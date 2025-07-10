using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEARBOOTS
#
###############################################################################

Class BEBearBoots : BEBoots {
    BEBearBoots() : base() {
		$this.Name               = 'Bear Boots'
		$this.MapObjName         = 'bearboots'
		$this.PurchasePrice      = 0
		$this.SellPrice          = 0
		$this.TargetStats        = @{
			[StatId]::Defense      = 999
			[StatId]::MagicDefense = 999
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The ultimate in fuzzy footwear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
    }
}
