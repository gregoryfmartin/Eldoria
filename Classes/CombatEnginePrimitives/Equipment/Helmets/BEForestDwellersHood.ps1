using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE FOREST DWELLERS HOOD
#
###############################################################################

Class BEForestDwellersHood : BEHelmet {
	BEForestDwellersHood() : base() {
		$this.Name               = 'Forest Dweller''s Hood'
		$this.MapObjName         = 'forestdwellershood'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood woven from leaves and vines, providing camouflage in forests.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
