using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDANCERSVEIL
#
###############################################################################

Class BEDancersVeil : BEArmor {
	BEDancersVeil() : base() {
		$this.Name               = 'Dancer''s Veil'
		$this.MapObjName         = 'dancersveil'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light, flowing garment that enhances agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
