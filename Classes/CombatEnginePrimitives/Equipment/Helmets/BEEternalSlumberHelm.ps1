using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETERNALSLUMBERHELM
#
###############################################################################

Class BEEternalSlumberHelm : BEHelmet {
	BEEternalSlumberHelm() : base() {
		$this.Name               = 'Eternal Slumber Helm'
		$this.MapObjName         = 'eternalslumberhelm'
		$this.PurchasePrice      = 7500
		$this.SellPrice          = 3750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 65
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that puts enemies into an eternal slumber, rendering them harmless.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
