using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPROPHETSCROWNOFFORETELLING
#
###############################################################################

Class BEProphetsCrownofForetelling : BEHelmet {
	BEProphetsCrownofForetelling() : base() {
		$this.Name               = 'Prophet''s Crown of Foretelling'
		$this.MapObjName         = 'prophetscrownofforetelling'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that grants glimpses of future events, both good and ill.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
