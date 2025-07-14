using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKNIGHTGREAVES
#
###############################################################################

Class BEKnightGreaves : BEGreaves {
	BEKnightGreaves() : base() {
		$this.Name               = 'Knight Greaves'
		$this.MapObjName         = 'knightgreaves'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves fit for a noble knight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
