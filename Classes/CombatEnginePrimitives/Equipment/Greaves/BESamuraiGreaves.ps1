using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAMURAIGREAVES
#
###############################################################################

Class BESamuraiGreaves : BEGreaves {
	BESamuraiGreaves() : base() {
		$this.Name               = 'Samurai Greaves'
		$this.MapObjName         = 'samuraigreaves'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::Defense = 34
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a disciplined warrior from the East.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
