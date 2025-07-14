using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENCHANTEDGREAVES
#
###############################################################################

Class BEEnchantedGreaves : BEGreaves {
	BEEnchantedGreaves() : base() {
		$this.Name               = 'Enchanted Greaves'
		$this.MapObjName         = 'enchantedgreaves'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves imbued with a minor enchantment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
