using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ENCHANTRESS'S CIRCLET
#
###############################################################################

Class BEEnchantresssCirclet : BEHelmet {
	BEEnchantresssCirclet() : base() {
		$this.Name               = 'Enchantress''s Circlet'
		$this.MapObjName         = 'enchantressscirclet'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet worn by enchantresses, boosting charming spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
