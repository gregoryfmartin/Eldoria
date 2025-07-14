using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNICORNHORNCHARM
#
###############################################################################

Class BEUnicornHornCharm : BEJewelry {
	BEUnicornHornCharm() : base() {
		$this.Name               = 'Unicorn Horn Charm'
		$this.MapObjName         = 'unicornhorncharm'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm crafted from a fragment of unicorn horn, for purity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
