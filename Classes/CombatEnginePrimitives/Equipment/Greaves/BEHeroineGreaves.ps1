using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEROINEGREAVES
#
###############################################################################

Class BEHeroineGreaves : BEGreaves {
	BEHeroineGreaves() : base() {
		$this.Name               = 'Heroine Greaves'
		$this.MapObjName         = 'heroinegreaves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a celebrated female hero.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
