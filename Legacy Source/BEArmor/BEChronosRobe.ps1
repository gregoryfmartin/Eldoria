using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHRONOSROBE
#
###############################################################################

Class BEChronosRobe : BEArmor {
	BEChronosRobe() : base() {
		$this.Name               = 'Chronos Robe'
		$this.MapObjName         = 'chronosrobe'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 39
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that seems to slightly bend time around the wearer, boosting speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
