using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONSTONEGREAVES
#
###############################################################################

Class BEMoonstoneGreaves : BEGreaves {
	BEMoonstoneGreaves() : base() {
		$this.Name               = 'Moonstone Greaves'
		$this.MapObjName         = 'moonstonegreaves'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that glow with lunar power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
