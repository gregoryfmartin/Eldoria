using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHELMOFWISDOM
#
###############################################################################

Class BEHelmofWisdom : BEHelmet {
	BEHelmofWisdom() : base() {
		$this.Name               = 'Helm of Wisdom'
		$this.MapObjName         = 'helmofwisdom'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helmet imbued with ancient knowledge, boosting a mage''s intellect.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
