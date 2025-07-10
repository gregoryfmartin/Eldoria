using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHAMANBOOTS
#
###############################################################################

Class BEShamanBoots : BEBoots {
	BEShamanBoots() : base() {
		$this.Name               = 'Shaman Boots'
		$this.MapObjName         = 'shamanboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a spiritual guide.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
