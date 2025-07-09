using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE FAIRY'S GARLAND
#
###############################################################################

Class BEFairysGarland : BEHelmet {
	BEFairysGarland() : base() {
		$this.Name               = 'Fairy''s Garland'
		$this.MapObjName         = 'fairysgarland'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate garland woven from enchanted flowers, granting subtle magical abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
