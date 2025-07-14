using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPROSPECTORGREAVES
#
###############################################################################

Class BEProspectorGreaves : BEGreaves {
	BEProspectorGreaves() : base() {
		$this.Name               = 'Prospector Greaves'
		$this.MapObjName         = 'prospectorgreaves'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for mineral seekers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
