using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIMENSIONSHIFTERSHELM
#
###############################################################################

Class BEDimensionShiftersHelm : BEHelmet {
	BEDimensionShiftersHelm() : base() {
		$this.Name               = 'Dimension Shifter''s Helm'
		$this.MapObjName         = 'dimensionshiftershelm'
		$this.PurchasePrice      = 5800
		$this.SellPrice          = 2900
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that allows the wearer to shift between dimensions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
