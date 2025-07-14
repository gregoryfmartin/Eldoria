using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARMASTERSGAUNTLETS
#
###############################################################################

Class BEWarmastersGauntlets : BEGauntlets {
	BEWarmastersGauntlets() : base() {
		$this.Name               = 'Warmaster''s Gauntlets'
		$this.MapObjName         = 'warmastersgauntlets'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a battle-hardened commander, commanding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
