using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREVENANTBOOTS
#
###############################################################################

Class BERevenantBoots : BEBoots {
	BERevenantBoots() : base() {
		$this.Name               = 'Revenant Boots'
		$this.MapObjName         = 'revenantboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of one returned from the grave.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
