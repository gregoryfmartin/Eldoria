using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENCHANTRESSSBANDS
#
###############################################################################

Class BEEnchantresssBands : BEGauntlets {
	BEEnchantresssBands() : base() {
		$this.Name               = 'Enchantress''s Bands'
		$this.MapObjName         = 'enchantresssbands'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands for a powerful enchantress, boosting all magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
