using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILKENENCHANTMENTGLOVES
#
###############################################################################

Class BESilkenEnchantmentGloves : BEGauntlets {
	BESilkenEnchantmentGloves() : base() {
		$this.Name               = 'Silken Enchantment Gloves'
		$this.MapObjName         = 'silkenenchantmentgloves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Silken gloves imbued with potent enchantments, boosting magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
