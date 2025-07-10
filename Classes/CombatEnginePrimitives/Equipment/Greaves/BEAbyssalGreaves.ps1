using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALGREAVES
#
###############################################################################

Class BEAbyssalGreaves : BEGreaves {
	BEAbyssalGreaves() : base() {
		$this.Name               = 'Abyssal Greaves'
		$this.MapObjName         = 'abyssalgreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves from the deepest chasms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
