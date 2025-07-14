using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECONQUERORBOOTS
#
###############################################################################

Class BEConquerorBoots : BEBoots {
	BEConquerorBoots() : base() {
		$this.Name               = 'Conqueror Boots'
		$this.MapObjName         = 'conquerorboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a victorious leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
