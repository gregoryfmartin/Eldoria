using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMINERBOOTS
#
###############################################################################

Class BEMinerBoots : BEBoots {
	BEMinerBoots() : base() {
		$this.Name               = 'Miner Boots'
		$this.MapObjName         = 'minerboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for underground excavation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
