using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIGHTBRINGERCHARM
#
###############################################################################

Class BELightbringerCharm : BEJewelry {
	BELightbringerCharm() : base() {
		$this.Name               = 'Lightbringer Charm'
		$this.MapObjName         = 'lightbringercharm'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm that emits a soft glow, dispelling darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
