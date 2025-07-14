using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMERSPAULDRON
#
###############################################################################

Class BEDreamersPauldron : BEPauldron {
	BEDreamersPauldron() : base() {
		$this.Name               = 'Dreamer''s Pauldron'
		$this.MapObjName         = 'dreamerspauldron'
		$this.PurchasePrice      = 7600
		$this.SellPrice          = 3800
		$this.TargetStats        = @{
			[StatId]::Defense = 152
			[StatId]::MagicDefense = 73
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows one to traverse dreams and access subconscious powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
