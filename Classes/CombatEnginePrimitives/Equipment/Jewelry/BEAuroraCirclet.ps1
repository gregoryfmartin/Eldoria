using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAURORACIRCLET
#
###############################################################################

Class BEAuroraCirclet : BEJewelry {
	BEAuroraCirclet() : base() {
		$this.Name               = 'Aurora Circlet'
		$this.MapObjName         = 'auroracirclet'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering circlet that glows with aurora colors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
