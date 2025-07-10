using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRAINERGREAVES
#
###############################################################################

Class BETrainerGreaves : BEGreaves {
	BETrainerGreaves() : base() {
		$this.Name               = 'Trainer Greaves'
		$this.MapObjName         = 'trainergreaves'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for skill development.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
