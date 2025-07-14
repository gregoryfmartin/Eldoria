using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHAMANSHANDWRAPS
#
###############################################################################

Class BEShamansHandwraps : BEGauntlets {
	BEShamansHandwraps() : base() {
		$this.Name               = 'Shaman''s Handwraps'
		$this.MapObjName         = 'shamanshandwraps'
		$this.PurchasePrice      = 490
		$this.SellPrice          = 245
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple wraps used in rituals, channeling natural magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
