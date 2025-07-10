using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENCHANTEDROBE
#
###############################################################################

Class BEEnchantedRobe : BEArmor {
	BEEnchantedRobe() : base() {
		$this.Name               = 'Enchanted Robe'
		$this.MapObjName         = 'enchantedrobe'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe imbued with minor magical properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
