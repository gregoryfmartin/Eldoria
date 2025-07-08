using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DANCER'S HEADPIECE
#
###############################################################################

Class BEDancersHeadpiece : BEHelmet {
	BEDancersHeadpiece() : base() {
		$this.Name               = 'Dancer''s Headpiece'
		$this.MapObjName         = 'dancersheadpiece'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An elaborate headpiece that complements a dancer''s movements and grace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
