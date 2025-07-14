using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELDRITCHROBE
#
###############################################################################

Class BEEldritchRobe : BEArmor {
	BEEldritchRobe() : base() {
		$this.Name               = 'Eldritch Robe'
		$this.MapObjName         = 'eldritchrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 36
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that subtly shifts patterns, enhancing forbidden magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
