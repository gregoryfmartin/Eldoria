using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPILGRIMGREAVES
#
###############################################################################

Class BEPilgrimGreaves : BEGreaves {
	BEPilgrimGreaves() : base() {
		$this.Name               = 'Pilgrim Greaves'
		$this.MapObjName         = 'pilgrimgreaves'
		$this.PurchasePrice      = 240
		$this.SellPrice          = 120
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for spiritual journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
