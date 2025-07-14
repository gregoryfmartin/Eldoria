using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRUIDSVINECHARM
#
###############################################################################

Class BEDruidsVineCharm : BEJewelry {
	BEDruidsVineCharm() : base() {
		$this.Name               = 'Druid''s Vine Charm'
		$this.MapObjName         = 'druidsvinecharm'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm woven from living vines, connecting to nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
