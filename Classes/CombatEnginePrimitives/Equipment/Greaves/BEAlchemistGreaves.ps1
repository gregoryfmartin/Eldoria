using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEALCHEMISTGREAVES
#
###############################################################################

Class BEAlchemistGreaves : BEGreaves {
	BEAlchemistGreaves() : base() {
		$this.Name               = 'Alchemist Greaves'
		$this.MapObjName         = 'alchemistgreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for those who transmute elements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
