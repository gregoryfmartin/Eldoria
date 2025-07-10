using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRUSADERSBREASTPLATE
#
###############################################################################

Class BECrusadersBreastplate : BEArmor {
	BECrusadersBreastplate() : base() {
		$this.Name               = 'Crusader''s Breastplate'
		$this.MapObjName         = 'crusadersbreastplate'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 23
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A holy breastplate, blessed against evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
