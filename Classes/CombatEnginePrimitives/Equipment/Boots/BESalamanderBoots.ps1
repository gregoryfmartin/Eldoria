using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESALAMANDERBOOTS
#
###############################################################################

Class BESalamanderBoots : BEBoots {
	BESalamanderBoots() : base() {
		$this.Name               = 'Salamander Boots'
		$this.MapObjName         = 'salamanderboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a fire spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
