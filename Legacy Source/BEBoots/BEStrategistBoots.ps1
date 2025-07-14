using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTRATEGISTBOOTS
#
###############################################################################

Class BEStrategistBoots : BEBoots {
	BEStrategistBoots() : base() {
		$this.Name               = 'Strategist Boots'
		$this.MapObjName         = 'strategistboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for grand scale planning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
