using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHILOSOPHERBOOTS
#
###############################################################################

Class BEPhilosopherBoots : BEBoots {
	BEPhilosopherBoots() : base() {
		$this.Name               = 'Philosopher Boots'
		$this.MapObjName         = 'philosopherboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for deep thinkers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
