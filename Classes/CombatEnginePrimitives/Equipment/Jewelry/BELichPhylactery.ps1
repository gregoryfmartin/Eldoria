using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELICHPHYLACTERY
#
###############################################################################

Class BELichPhylactery : BEJewelry {
	BELichPhylactery() : base() {
		$this.Name               = 'Lich Phylactery'
		$this.MapObjName         = 'lichphylactery'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicAttack = 4
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, pulsating phylactery, containing a lich''s essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
