using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRAINERBOOTS
#
###############################################################################

Class BETrainerBoots : BEBoots {
	BETrainerBoots() : base() {
		$this.Name               = 'Trainer Boots'
		$this.MapObjName         = 'trainerboots'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for skill development.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
