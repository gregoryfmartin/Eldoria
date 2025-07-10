using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICHANDGUARDS
#
###############################################################################

Class BEMysticHandguards : BEGauntlets {
	BEMysticHandguards() : base() {
		$this.Name               = 'Mystic Handguards'
		$this.MapObjName         = 'mystichandguards'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with faint arcane energy, boosting magic defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
