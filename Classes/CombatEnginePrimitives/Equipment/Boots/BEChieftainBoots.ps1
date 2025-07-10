using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHIEFTAINBOOTS
#
###############################################################################

Class BEChieftainBoots : BEBoots {
	BEChieftainBoots() : base() {
		$this.Name               = 'Chieftain Boots'
		$this.MapObjName         = 'chieftainboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a tribal leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
