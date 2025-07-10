using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLOCKSWRAPS
#
###############################################################################

Class BEWarlocksWraps : BEGauntlets {
	BEWarlocksWraps() : base() {
		$this.Name               = 'Warlock''s Wraps'
		$this.MapObjName         = 'warlockswraps'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark wraps enhancing destructive magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
