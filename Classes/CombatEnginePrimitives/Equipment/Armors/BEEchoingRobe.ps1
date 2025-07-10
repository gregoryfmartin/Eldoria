using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEECHOINGROBE
#
###############################################################################

Class BEEchoingRobe : BEArmor {
	BEEchoingRobe() : base() {
		$this.Name               = 'Echoing Robe'
		$this.MapObjName         = 'echoingrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that amplifies spells, but leaves residual magical echoes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
