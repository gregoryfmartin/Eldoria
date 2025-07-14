using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOURAGEGREAVES
#
###############################################################################

Class BECourageGreaves : BEGreaves {
	BECourageGreaves() : base() {
		$this.Name               = 'Courage Greaves'
		$this.MapObjName         = 'couragegreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that instill bravery.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
