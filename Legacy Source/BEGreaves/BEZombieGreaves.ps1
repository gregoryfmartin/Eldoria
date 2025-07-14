using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZOMBIEGREAVES
#
###############################################################################

Class BEZombieGreaves : BEGreaves {
	BEZombieGreaves() : base() {
		$this.Name               = 'Zombie Greaves'
		$this.MapObjName         = 'zombiegreaves'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rotting greaves, barely functional.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
