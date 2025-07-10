using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWPAULDRON
#
###############################################################################

Class BEShadowPauldron : BEPauldron {
	BEShadowPauldron() : base() {
		$this.Name               = 'Shadow Pauldron'
		$this.MapObjName         = 'shadowpauldron'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{
			[StatId]::Defense = 33
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grants concealment and enhances stealth, for those who walk in shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
