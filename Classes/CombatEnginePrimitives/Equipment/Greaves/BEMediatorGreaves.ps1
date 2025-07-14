using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMEDIATORGREAVES
#
###############################################################################

Class BEMediatorGreaves : BEGreaves {
	BEMediatorGreaves() : base() {
		$this.Name               = 'Mediator Greaves'
		$this.MapObjName         = 'mediatorgreaves'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for resolving conflicts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
