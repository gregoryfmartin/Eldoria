using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SPIRITBOND CIRCLET
#
###############################################################################

Class BESpiritbondCirclet : BEHelmet {
	BESpiritbondCirclet() : base() {
		$this.Name               = 'Spiritbond Circlet'
		$this.MapObjName         = 'spiritbondcirclet'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that creates a strong bond with a companion spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
