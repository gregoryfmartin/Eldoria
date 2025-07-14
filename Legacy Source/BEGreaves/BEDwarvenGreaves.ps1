using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDWARVENGREAVES
#
###############################################################################

Class BEDwarvenGreaves : BEGreaves {
	BEDwarvenGreaves() : base() {
		$this.Name               = 'Dwarven Greaves'
		$this.MapObjName         = 'dwarvengreaves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Robust greaves forged by dwarven artisans.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
