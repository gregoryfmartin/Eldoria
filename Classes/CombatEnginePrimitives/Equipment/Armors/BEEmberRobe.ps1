using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMBERROBE
#
###############################################################################

Class BEEmberRobe : BEArmor {
	BEEmberRobe() : base() {
		$this.Name               = 'Ember Robe'
		$this.MapObjName         = 'emberrobe'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that radiates a faint warmth, hinting at fire magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
