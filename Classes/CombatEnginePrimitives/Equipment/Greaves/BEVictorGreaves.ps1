using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVICTORGREAVES
#
###############################################################################

Class BEVictorGreaves : BEGreaves {
	BEVictorGreaves() : base() {
		$this.Name               = 'Victor Greaves'
		$this.MapObjName         = 'victorgreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves worn by those who claim victory.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
