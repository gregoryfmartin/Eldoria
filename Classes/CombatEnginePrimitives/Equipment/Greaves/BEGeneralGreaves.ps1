using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGENERALGREAVES
#
###############################################################################

Class BEGeneralGreaves : BEGreaves {
	BEGeneralGreaves() : base() {
		$this.Name               = 'General Greaves'
		$this.MapObjName         = 'generalgreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves fit for a military general.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
