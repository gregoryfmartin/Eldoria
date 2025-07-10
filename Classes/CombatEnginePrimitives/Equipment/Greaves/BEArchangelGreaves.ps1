using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCHANGELGREAVES
#
###############################################################################

Class BEArchangelGreaves : BEGreaves {
	BEArchangelGreaves() : base() {
		$this.Name               = 'Archangel Greaves'
		$this.MapObjName         = 'archangelgreaves'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of the highest order of angels.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
