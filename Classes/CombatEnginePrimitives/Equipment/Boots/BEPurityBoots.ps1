using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPURITYBOOTS
#
###############################################################################

Class BEPurityBoots : BEBoots {
	BEPurityBoots() : base() {
		$this.Name               = 'Purity Boots'
		$this.MapObjName         = 'purityboots'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of untainted essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
