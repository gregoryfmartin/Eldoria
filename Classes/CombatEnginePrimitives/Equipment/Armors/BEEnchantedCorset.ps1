using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENCHANTEDCORSET
#
###############################################################################

Class BEEnchantedCorset : BEArmor {
	BEEnchantedCorset() : base() {
		$this.Name               = 'Enchanted Corset'
		$this.MapObjName         = 'enchantedcorset'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A reinforced corset imbued with minor protective enchantments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
