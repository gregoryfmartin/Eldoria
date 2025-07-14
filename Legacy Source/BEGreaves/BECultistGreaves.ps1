using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECULTISTGREAVES
#
###############################################################################

Class BECultistGreaves : BEGreaves {
	BECultistGreaves() : base() {
		$this.Name               = 'Cultist Greaves'
		$this.MapObjName         = 'cultistgreaves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves worn by a dark cult.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
