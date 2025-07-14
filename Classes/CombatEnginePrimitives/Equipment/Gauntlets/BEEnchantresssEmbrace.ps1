using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENCHANTRESSSEMBRACE
#
###############################################################################

Class BEEnchantresssEmbrace : BEGauntlets {
	BEEnchantresssEmbrace() : base() {
		$this.Name               = 'Enchantress''s Embrace'
		$this.MapObjName         = 'enchantresssembrace'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Advanced bands for a master enchantress, supreme magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
