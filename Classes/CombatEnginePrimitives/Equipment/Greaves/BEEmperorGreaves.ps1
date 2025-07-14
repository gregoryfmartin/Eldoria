using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMPERORGREAVES
#
###############################################################################

Class BEEmperorGreaves : BEGreaves {
	BEEmperorGreaves() : base() {
		$this.Name               = 'Emperor Greaves'
		$this.MapObjName         = 'emperorgreaves'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of an undisputed ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
