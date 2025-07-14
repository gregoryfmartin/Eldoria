using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHRONOSHELM
#
###############################################################################

Class BEChronosHelm : BEHelmet {
	BEChronosHelm() : base() {
		$this.Name               = 'Chronos Helm'
		$this.MapObjName         = 'chronoshelm'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with the power of time, allowing minor temporal manipulation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
