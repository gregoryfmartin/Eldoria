using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAMPIONBOOTS
#
###############################################################################

Class BEChampionBoots : BEBoots {
	BEChampionBoots() : base() {
		$this.Name               = 'Champion Boots'
		$this.MapObjName         = 'championboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an undisputed champion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
