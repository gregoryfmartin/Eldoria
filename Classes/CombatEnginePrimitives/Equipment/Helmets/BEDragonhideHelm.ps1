using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DRAGONHIDE HELM
#
###############################################################################

Class BEDragonhideHelm : BEHelmet {
	BEDragonhideHelm() : base() {
		$this.Name               = 'Dragonhide Helm'
		$this.MapObjName         = 'dragonhidehelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crafted from the scales of a dragon, offering exceptional protection against fire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
