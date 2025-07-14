using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETITANSLEGACYBREASTPLATE
#
###############################################################################

Class BETitansLegacyBreastplate : BEArmor {
	BETitansLegacyBreastplate() : base() {
		$this.Name               = 'Titan''s Legacy Breastplate'
		$this.MapObjName         = 'titanslegacybreastplate'
		$this.PurchasePrice      = 2900
		$this.SellPrice          = 1450
		$this.TargetStats        = @{
			[StatId]::Defense = 39
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate said to be a fragment of a titan''s armor, immense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
