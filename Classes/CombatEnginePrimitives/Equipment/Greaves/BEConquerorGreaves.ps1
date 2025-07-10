using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECONQUERORGREAVES
#
###############################################################################

Class BEConquerorGreaves : BEGreaves {
	BEConquerorGreaves() : base() {
		$this.Name               = 'Conqueror Greaves'
		$this.MapObjName         = 'conquerorgreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a victorious leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
