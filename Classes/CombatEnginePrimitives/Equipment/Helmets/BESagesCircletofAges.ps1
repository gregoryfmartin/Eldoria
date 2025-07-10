using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAGESCIRCLETOFAGES
#
###############################################################################

Class BESagesCircletofAges : BEHelmet {
	BESagesCircletofAges() : base() {
		$this.Name               = 'Sage''s Circlet of Ages'
		$this.MapObjName         = 'sagescircletofages'
		$this.PurchasePrice      = 3200
		$this.SellPrice          = 1600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that grants access to the wisdom of all ages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
