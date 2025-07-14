using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETACTICIANBOOTS
#
###############################################################################

Class BETacticianBoots : BEBoots {
	BETacticianBoots() : base() {
		$this.Name               = 'Tactician Boots'
		$this.MapObjName         = 'tacticianboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for strategic thinkers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
