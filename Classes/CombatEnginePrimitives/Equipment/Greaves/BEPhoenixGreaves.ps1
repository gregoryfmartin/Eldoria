using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXGREAVES
#
###############################################################################

Class BEPhoenixGreaves : BEGreaves {
	BEPhoenixGreaves() : base() {
		$this.Name               = 'Phoenix Greaves'
		$this.MapObjName         = 'phoenixgreaves'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that glow with fiery essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
