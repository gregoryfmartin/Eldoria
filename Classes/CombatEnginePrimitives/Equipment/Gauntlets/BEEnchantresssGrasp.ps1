using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENCHANTRESSSGRASP
#
###############################################################################

Class BEEnchantresssGrasp : BEGauntlets {
	BEEnchantresssGrasp() : base() {
		$this.Name               = 'Enchantress''s Grasp'
		$this.MapObjName         = 'enchantresssgrasp'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate bands for an enchantress, absolute magical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
