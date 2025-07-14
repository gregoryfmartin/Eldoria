using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMEDIATORBOOTS
#
###############################################################################

Class BEMediatorBoots : BEBoots {
	BEMediatorBoots() : base() {
		$this.Name               = 'Mediator Boots'
		$this.MapObjName         = 'mediatorboots'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for resolving conflicts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
