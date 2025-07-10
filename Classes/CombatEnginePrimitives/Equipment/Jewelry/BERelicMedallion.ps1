using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERELICMEDALLION
#
###############################################################################

Class BERelicMedallion : BEJewelry {
	BERelicMedallion() : base() {
		$this.Name               = 'Relic Medallion'
		$this.MapObjName         = 'relicmedallion'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 2
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A powerful medallion from a forgotten age.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
