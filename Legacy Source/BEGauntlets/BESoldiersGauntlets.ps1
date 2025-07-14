using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOLDIERSGAUNTLETS
#
###############################################################################

Class BESoldiersGauntlets : BEGauntlets {
	BESoldiersGauntlets() : base() {
		$this.Name               = 'Soldier''s Gauntlets'
		$this.MapObjName         = 'soldiersgauntlets'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Standard issue gauntlets for army soldiers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
