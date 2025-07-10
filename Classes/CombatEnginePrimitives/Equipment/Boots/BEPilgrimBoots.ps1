using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPILGRIMBOOTS
#
###############################################################################

Class BEPilgrimBoots : BEBoots {
	BEPilgrimBoots() : base() {
		$this.Name               = 'Pilgrim Boots'
		$this.MapObjName         = 'pilgrimboots'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for spiritual journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
