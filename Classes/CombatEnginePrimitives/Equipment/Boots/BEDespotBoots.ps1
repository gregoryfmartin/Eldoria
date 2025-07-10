using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESPOTBOOTS
#
###############################################################################

Class BEDespotBoots : BEBoots {
	BEDespotBoots() : base() {
		$this.Name               = 'Despot Boots'
		$this.MapObjName         = 'despotboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an absolute ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
