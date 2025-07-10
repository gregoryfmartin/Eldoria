using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORESTDWELLERSTUNIC
#
###############################################################################

Class BEForestDwellersTunic : BEArmor {
	BEForestDwellersTunic() : base() {
		$this.Name               = 'Forest Dweller''s Tunic'
		$this.MapObjName         = 'forestdwellerstunic'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A green tunic that blends in with natural environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
