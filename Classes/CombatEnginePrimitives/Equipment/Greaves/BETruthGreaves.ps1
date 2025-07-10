using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRUTHGREAVES
#
###############################################################################

Class BETruthGreaves : BEGreaves {
	BETruthGreaves() : base() {
		$this.Name               = 'Truth Greaves'
		$this.MapObjName         = 'truthgreaves'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that reveal falsehoods.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
