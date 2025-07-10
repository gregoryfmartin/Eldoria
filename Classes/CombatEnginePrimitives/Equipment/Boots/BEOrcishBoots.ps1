using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORCISHBOOTS
#
###############################################################################

Class BEOrcishBoots : BEBoots {
	BEOrcishBoots() : base() {
		$this.Name               = 'Orcish Boots'
		$this.MapObjName         = 'orcishboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and brutal boots of orcs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
