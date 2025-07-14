using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENCHANTRESSSGOWN
#
###############################################################################

Class BEEnchantresssGown : BEArmor {
	BEEnchantresssGown() : base() {
		$this.Name               = 'Enchantress''s Gown'
		$this.MapObjName         = 'enchantresssgown'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gown of exquisite design, perfect for casting powerful spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
