using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMISTVEILSHAWL
#
###############################################################################

Class BEMistveilShawl : BEJewelry {
	BEMistveilShawl() : base() {
		$this.Name               = 'Mistveil Shawl'
		$this.MapObjName         = 'mistveilshawl'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering shawl that creates a light mist.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
