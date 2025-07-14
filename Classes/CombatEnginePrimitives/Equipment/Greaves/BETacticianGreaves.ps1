using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETACTICIANGREAVES
#
###############################################################################

Class BETacticianGreaves : BEGreaves {
	BETacticianGreaves() : base() {
		$this.Name               = 'Tactician Greaves'
		$this.MapObjName         = 'tacticiangreaves'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for strategic thinkers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
