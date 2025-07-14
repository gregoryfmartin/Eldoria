using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNDERDARKGREAVES
#
###############################################################################

Class BEUnderdarkGreaves : BEGreaves {
	BEUnderdarkGreaves() : base() {
		$this.Name               = 'Underdark Greaves'
		$this.MapObjName         = 'underdarkgreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for the deep and dangerous underground.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
