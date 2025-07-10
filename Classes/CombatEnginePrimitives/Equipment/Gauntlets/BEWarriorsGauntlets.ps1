using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARRIORSGAUNTLETS
#
###############################################################################

Class BEWarriorsGauntlets : BEGauntlets {
	BEWarriorsGauntlets() : base() {
		$this.Name               = 'Warrior''s Gauntlets'
		$this.MapObjName         = 'warriorsgauntlets'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Solid gauntlets for frontline fighters, focusing on physical defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
