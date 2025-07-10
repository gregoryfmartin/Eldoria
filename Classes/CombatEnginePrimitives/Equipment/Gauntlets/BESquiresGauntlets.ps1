using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESQUIRESGAUNTLETS
#
###############################################################################

Class BESquiresGauntlets : BEGauntlets {
	BESquiresGauntlets() : base() {
		$this.Name               = 'Squire''s Gauntlets'
		$this.MapObjName         = 'squiresgauntlets'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets for a young knight in training.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
