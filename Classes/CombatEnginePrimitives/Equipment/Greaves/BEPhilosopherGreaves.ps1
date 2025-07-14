using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHILOSOPHERGREAVES
#
###############################################################################

Class BEPhilosopherGreaves : BEGreaves {
	BEPhilosopherGreaves() : base() {
		$this.Name               = 'Philosopher Greaves'
		$this.MapObjName         = 'philosophergreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for deep thinkers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
