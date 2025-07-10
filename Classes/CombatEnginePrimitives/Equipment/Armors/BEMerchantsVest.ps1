using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMERCHANTSVEST
#
###############################################################################

Class BEMerchantsVest : BEArmor {
	BEMerchantsVest() : base() {
		$this.Name               = 'Merchant''s Vest'
		$this.MapObjName         = 'merchantsvest'
		$this.PurchasePrice      = 95
		$this.SellPrice          = 48
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple vest with hidden pockets, provides little defense.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
