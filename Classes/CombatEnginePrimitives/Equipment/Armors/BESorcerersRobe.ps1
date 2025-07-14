using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESORCERERSROBE
#
###############################################################################

Class BESorcerersRobe : BEArmor {
	BESorcerersRobe() : base() {
		$this.Name               = 'Sorcerer''s Robe'
		$this.MapObjName         = 'sorcerersrobe'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe designed to amplify magical incantations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
