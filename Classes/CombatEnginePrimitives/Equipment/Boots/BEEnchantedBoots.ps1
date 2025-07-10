using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENCHANTEDBOOTS
#
###############################################################################

Class BEEnchantedBoots : BEBoots {
	BEEnchantedBoots() : base() {
		$this.Name               = 'Enchanted Boots'
		$this.MapObjName         = 'enchantedboots'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 23
			[StatId]::MagicDefense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots imbued with a minor enchantment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
