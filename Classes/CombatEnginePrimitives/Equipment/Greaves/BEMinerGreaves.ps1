using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMINERGREAVES
#
###############################################################################

Class BEMinerGreaves : BEGreaves {
	BEMinerGreaves() : base() {
		$this.Name               = 'Miner Greaves'
		$this.MapObjName         = 'minergreaves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for underground excavation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
