using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULFIREROBE
#
###############################################################################

Class BESoulfireRobe : BEArmor {
	BESoulfireRobe() : base() {
		$this.Name               = 'Soulfire Robe'
		$this.MapObjName         = 'soulfirerobe'
		$this.PurchasePrice      = 1950
		$this.SellPrice          = 975
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 37
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe imbued with captured souls, radiating dark energy and boosting spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
