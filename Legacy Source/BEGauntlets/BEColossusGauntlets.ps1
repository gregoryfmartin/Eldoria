using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOLOSSUSGAUNTLETS
#
###############################################################################

Class BEColossusGauntlets : BEGauntlets {
	BEColossusGauntlets() : base() {
		$this.Name               = 'Colossus Gauntlets'
		$this.MapObjName         = 'colossusgauntlets'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 98
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Massive gauntlets for a champion, empowering strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
