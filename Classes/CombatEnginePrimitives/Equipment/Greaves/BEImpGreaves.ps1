using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIMPGREAVES
#
###############################################################################

Class BEImpGreaves : BEGreaves {
	BEImpGreaves() : base() {
		$this.Name               = 'Imp Greaves'
		$this.MapObjName         = 'impgreaves'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Small but surprisingly tough greaves.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
