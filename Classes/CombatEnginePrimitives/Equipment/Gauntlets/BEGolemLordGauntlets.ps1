using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMLORDGAUNTLETS
#
###############################################################################

Class BEGolemLordGauntlets : BEGauntlets {
	BEGolemLordGauntlets() : base() {
		$this.Name               = 'Golem Lord Gauntlets'
		$this.MapObjName         = 'golemlordgauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a golem lord, commanding immense strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
