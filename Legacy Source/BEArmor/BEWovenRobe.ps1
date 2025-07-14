using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWOVENROBE
#
###############################################################################

Class BEWovenRobe : BEArmor {
	BEWovenRobe() : base() {
		$this.Name               = 'Woven Robe'
		$this.MapObjName         = 'wovenrobe'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple robe made from woven plant fibers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
