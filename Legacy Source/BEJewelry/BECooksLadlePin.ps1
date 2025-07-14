using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOOKSLADLEPIN
#
###############################################################################

Class BECooksLadlePin : BEJewelry {
	BECooksLadlePin() : base() {
		$this.Name               = 'Cook''s Ladle Pin'
		$this.MapObjName         = 'cooksladlepin'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a small ladle, for culinary prowess.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
