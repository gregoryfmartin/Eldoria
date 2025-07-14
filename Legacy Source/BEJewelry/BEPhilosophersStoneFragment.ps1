using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHILOSOPHERSSTONEFRAGMENT
#
###############################################################################

Class BEPhilosophersStoneFragment : BEJewelry {
	BEPhilosophersStoneFragment() : base() {
		$this.Name               = 'Philosopher''s Stone Fragment'
		$this.MapObjName         = 'philosophersstonefragment'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
			[StatId]::Luck = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny fragment of the legendary Philosopher''s Stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
