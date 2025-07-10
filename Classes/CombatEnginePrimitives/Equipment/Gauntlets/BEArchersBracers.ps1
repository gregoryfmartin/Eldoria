using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCHERSBRACERS
#
###############################################################################

Class BEArchersBracers : BEGauntlets {
	BEArchersBracers() : base() {
		$this.Name               = 'Archer''s Bracers'
		$this.MapObjName         = 'archersbracers'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 4
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and flexible bracers for archers, aiding aim.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
