using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLIGHTEDGREAVES
#
###############################################################################

Class BEBlightedGreaves : BEGreaves {
	BEBlightedGreaves() : base() {
		$this.Name               = 'Blighted Greaves'
		$this.MapObjName         = 'blightedgreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves afflicted by a terrible curse.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
