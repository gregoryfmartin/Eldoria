using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPRITESLEAFHAT
#
###############################################################################

Class BESpritesLeafHat : BEHelmet {
	BESpritesLeafHat() : base() {
		$this.Name               = 'Sprite''s Leaf Hat'
		$this.MapObjName         = 'spritesleafhat'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny hat woven from magical leaves, granting illusionary abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
