using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLOOMROBE
#
###############################################################################

Class BEGloomRobe : BEArmor {
	BEGloomRobe() : base() {
		$this.Name               = 'Gloom Robe'
		$this.MapObjName         = 'gloomrobe'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, plain robe for those who prefer to remain unnoticed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
