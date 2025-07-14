using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFERNOFISTS
#
###############################################################################

Class BEInfernoFists : BEGauntlets {
	BEInfernoFists() : base() {
		$this.Name               = 'Inferno Fists'
		$this.MapObjName         = 'infernofists'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets ablaze with eternal flames, burning all who touch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
