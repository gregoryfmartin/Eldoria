using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRONZEFISTS
#
###############################################################################

Class BEBronzeFists : BEGauntlets {
	BEBronzeFists() : base() {
		$this.Name               = 'Bronze Fists'
		$this.MapObjName         = 'bronzefists'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude but sturdy bronze gauntlets, heavy and reliable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
