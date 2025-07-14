using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOGREGREAVES
#
###############################################################################

Class BEOgreGreaves : BEGreaves {
	BEOgreGreaves() : base() {
		$this.Name               = 'Ogre Greaves'
		$this.MapObjName         = 'ogregreaves'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Massive greaves for immense creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
