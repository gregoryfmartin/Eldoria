using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELEMENTALLORDSCROWN
#
###############################################################################

Class BEElementalLordsCrown : BEHelmet {
	BEElementalLordsCrown() : base() {
		$this.Name               = 'Elemental Lord''s Crown'
		$this.MapObjName         = 'elementallordscrown'
		$this.PurchasePrice      = 14000
		$this.SellPrice          = 7000
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that grants mastery over all four classical elements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
