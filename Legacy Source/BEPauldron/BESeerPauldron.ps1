using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESEERPAULDRON
#
###############################################################################

Class BESeerPauldron : BEPauldron {
	BESeerPauldron() : base() {
		$this.Name               = 'Seer Pauldron'
		$this.MapObjName         = 'seerpauldron'
		$this.PurchasePrice      = 7450
		$this.SellPrice          = 3725
		$this.TargetStats        = @{
			[StatId]::Defense = 149
			[StatId]::MagicDefense = 70
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances perception and allows for detection of hidden truths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
