using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGARGOYLEGREAVES
#
###############################################################################

Class BEGargoyleGreaves : BEGreaves {
	BEGargoyleGreaves() : base() {
		$this.Name               = 'Gargoyle Greaves'
		$this.MapObjName         = 'gargoylegreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Stone greaves, offering immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
