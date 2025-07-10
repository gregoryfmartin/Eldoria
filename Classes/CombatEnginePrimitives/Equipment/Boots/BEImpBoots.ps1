using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIMPBOOTS
#
###############################################################################

Class BEImpBoots : BEBoots {
	BEImpBoots() : base() {
		$this.Name               = 'Imp Boots'
		$this.MapObjName         = 'impboots'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Small but surprisingly tough boots.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
