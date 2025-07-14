using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGUARDIANSBREASTPLATE
#
###############################################################################

Class BEGuardiansBreastplate : BEArmor {
	BEGuardiansBreastplate() : base() {
		$this.Name               = 'Guardian''s Breastplate'
		$this.MapObjName         = 'guardiansbreastplate'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy breastplate designed for protectors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
